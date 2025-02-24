import 'dart:convert';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:http/http.dart' as http;
import 'package:beautilly/core/error/exceptions.dart';
import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/core/utils/constant/api_endpoints.dart';
import 'package:beautilly/features/notifications/data/models/notification_model.dart';
import 'package:beautilly/features/auth/domain/repositories/auth_repository.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationsResponse> getNotifications({int page = 1});
  Future<void> markAsRead(String notificationId);
}

class NotificationsRemoteDataSourceImpl
    with TokenRefreshMixin
    implements NotificationsRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;
  final AuthRepository authRepository;

  NotificationsRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
    required this.authRepository,
  });

  @override
  Future<NotificationsResponse> getNotifications({int page = 1}) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        try {
          final sessionCookie = await cacheService.getSessionCookie();

          final response = await client.get(
            Uri.parse(ApiEndpoints.notifications),
            headers: {
              'Authorization': 'Bearer $token',
              'x-api-key': ApiEndpoints.api_key,
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              if (sessionCookie != null) 'Cookie': sessionCookie,
            },
          );

          final responseBody =
              utf8.decode(response.bodyBytes); // لمعالجة الأحرف العربية

          if (response.statusCode == 200) {
            final jsonResponse = json.decode(responseBody);
            if (jsonResponse['success'] == true) {
              return NotificationsResponse.fromJson(jsonResponse);
            } else {
              throw ServerException(
                  message: jsonResponse['message'] ?? 'فشل في تحميل الإشعارات');
            }
          } else if (response.statusCode == 401) {
            throw UnauthorizedException('يرجى تسجيل الدخول مرة أخرى');
          } else {
            throw ServerException(message: 'فشل في تحميل الإشعارات');
          }
        } catch (e, stackTrace) {
          if (e is UnauthorizedException) {
            rethrow;
          }
          throw ServerException(
              message: 'حدث خطأ في تحميل الإشعارات، يرجى المحاولة مرة أخرى');
        }
      },
    );
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();

        final response = await client.post(
          Uri.parse(
              '${ApiEndpoints.baseUrl}/notifications/$notificationId/read'),
          headers: {
            'Authorization': 'Bearer $token',
            'x-api-key': ApiEndpoints.api_key,
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
        );

        if (response.statusCode != 200) {
          final error = json.decode(response.body);
          throw ServerException(
              message: error['message'] ?? 'فشل في تحديث حالة الإشعار');
        }
      },
    );
  }
}
