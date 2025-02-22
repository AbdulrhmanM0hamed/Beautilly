import 'dart:convert';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:http/http.dart' as http;
import 'package:beautilly/core/error/exceptions.dart';
import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/core/utils/constant/api_endpoints.dart';
import 'package:beautilly/features/notifications/data/models/notification_model.dart';
import 'package:beautilly/features/auth/domain/repositories/auth_repository.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String notificationId);
}

class NotificationsRemoteDataSourceImpl with TokenRefreshMixin implements NotificationsRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;
  final AuthRepository authRepository;

  NotificationsRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
    required this.authRepository,
  });

  @override
  Future<List<NotificationModel>> getNotifications() async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();
        
        print('🔍 Notifications Request:');
        print('Token: ${token.substring(0, 20)}...');  // نطبع جزء من التوكن للتحقق
        print('Cookie: $sessionCookie');

        final response = await client.get(
          Uri.parse(ApiEndpoints.notifications),
          headers: {
            'Authorization': 'Bearer $token',
            'x-api-key': ApiEndpoints.api_key,
            'Accept': 'application/json',
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
        );

        print('📄 Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          if (jsonResponse['success'] == true) {
            final notifications = jsonResponse['notifications'] as List;
            return notifications
                .map((notification) => NotificationModel.fromJson(notification))
                .toList();
          }
        } else if (response.statusCode == 401) {
          print('❌ Token validation failed');
          // نحاول تجديد التوكن
          final newToken = await authRepository.refreshToken();
          if (newToken.isRight()) {
            print('✅ Token refreshed, retrying request');
            return getNotifications();  // نعيد المحاولة بالتوكن الجديد
          }
        }
        
        final error = json.decode(response.body);
        throw ServerException(
          message: error['message'] ?? 'فشل في تحميل الإشعارات'
        );
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
          Uri.parse('${ApiEndpoints.baseUrl}/notifications/$notificationId/read'),
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
            message: error['message'] ?? 'فشل في تحديث حالة الإشعار'
          );
        }
      },
    );
  }
}