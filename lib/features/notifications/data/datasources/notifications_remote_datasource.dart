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
  Future<void> DeleteNorifications();
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
    try {
      //     print('🔍 جاري جلب الإشعارات...');
      //     print('📄 الصفحة: $page');

      final token = await cacheService.getToken();
      final sessionCookie = await cacheService.getSessionCookie();

      //    print('🔑 Token: $token');
      //     print('🍪 Session Cookie: $sessionCookie');

      final response = await client.get(
        Uri.parse(ApiEndpoints.notifications),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      //    print('📥 Response Status: ${response.statusCode}');
      //  print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        //    print('✅ تم جلب الإشعارات بنجاح');
        return NotificationsResponse.fromJson(jsonResponse);
      } else {
        //    print('❌ خطأ في استجابة الخادم: ${response.statusCode}');
        throw ServerException(
          message: json.decode(response.body)['message'] ??
              'حدث خطأ في تحميل الإشعارات',
        );
      }
    } catch (e, stackTrace) {
      // print('❌ خطأ غير متوقع: $e');
      // print('📚 Stack trace: $stackTrace');
      throw ServerException(
        message: 'حدث خطأ في تحميل الإشعارات، يرجى المحاولة مرة أخرى',
      );
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        try {
          final response = await client.post(
            Uri.parse(
                '${ApiEndpoints.baseUrl}/notifications/$notificationId/read'),
            headers: await _getHeaders(),
          );

          if (response.statusCode != 200) {
            final error = json.decode(response.body);
            throw ServerException(
              message: error['message'] ?? 'فشل في تحديث حالة الإشعار',
            );
          }
        } catch (e) {
          throw ServerException(
            message: 'حدث خطأ في تحديث حالة الإشعار',
          );
        }
      },
    );
  }

  @override
  Future<void> DeleteNorifications() async {
    try {
      final headers = await _getHeaders();

      final url = Uri.parse(ApiEndpoints.notificationsDelete);

      final response = await client.delete(
        url,
        headers: headers,
      );

      if (response.statusCode != 200) {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'حدث خطأ في حذف الإشعارات';
        throw ServerException(
          message: errorMessage,
        );
      }
    } catch (e, stackTrace) {
      throw ServerException(
        message: 'حدث خطأ في حذف الإشعارات',
      );
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async => token,
    );

    final sessionCookie = await cacheService.getSessionCookie();
    return {
      'Authorization': 'Bearer $token',
      'x-api-key': ApiEndpoints.api_key,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (sessionCookie != null) 'Cookie': sessionCookie,
    };
  }
}
