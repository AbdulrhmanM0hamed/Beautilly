import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';
import '../models/profile_model.dart';
import '../models/change_password_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<String> updateAvatar(File image);
  Future<ProfileModel> updateProfile({
    String? name,
    String? email,
    String? phone,
  });
  Future<ProfileModel> updateAddress({
    required int cityId,
    required int stateId,
  });
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
  Future<bool> updateNotificationSettings({required bool enabled});
  Future<String> verifyEmail();
  Future<String> resendVerificationCode();
  Future<String> deleteAccount({required String password});
}

class ProfileRemoteDataSourceImpl
    with TokenRefreshMixin
    implements ProfileRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;
  final AuthRepository authRepository;

  ProfileRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
    required this.authRepository,
  });

     @override
  Future<ProfileModel> getProfile() async {
    print('🔵 [getProfile] بدء استدعاء البيانات');

    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        print('🟢 [getProfile] تم جلب التوكن: $token');

        final sessionCookie = await cacheService.getSessionCookie();
        print('🟠 [getProfile] تم جلب الكوكيز: $sessionCookie');

        try {
          final response = await client.get(
            Uri.parse(ApiEndpoints.profile),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'x-api-key': ApiEndpoints.api_key,
              if (sessionCookie != null) 'Cookie': sessionCookie,
            },
          );

          print('🔵 [getProfile] تم استلام الاستجابة، الحالة: ${response.statusCode}');
          print('🟢 [getProfile] الاستجابة الكاملة: ${response.body}');

          if (response.statusCode == 200) {
            final jsonResponse = json.decode(response.body);
            print('🟠 [getProfile] تم فك تشفير JSON: $jsonResponse');

            if (jsonResponse['success'] == true) {
              final data = jsonResponse['data'];
              
              if (data == null) {
                print('❌ [getProfile] البيانات المستلمة هي null!');
                throw ServerException(message: 'بيانات الملف الشخصي غير متوفرة');
              }

              final profile = ProfileModel.fromJson(data);
              print('✅ [getProfile] تم إنشاء كائن ProfileModel بنجاح');
              return profile;
            } else {
              print('❌ [getProfile] خطأ في الاستجابة: ${jsonResponse['message']}');
              throw ServerException(
                message: jsonResponse['message'] ?? 'فشل في تحميل بيانات الملف الشخصي',
              );
            }
          } else {
            print('❌ [getProfile] استجابة غير متوقعة، الحالة: ${response.statusCode}');
            throw ServerException(message: 'فشل في تحميل بيانات الملف الشخصي');
          }
        } catch (e) {
          print('🚨 [getProfile] حدث خطأ غير متوقع: $e');
          throw ServerException(message: 'حدث خطأ غير متوقع أثناء جلب بيانات الملف الشخصي');
        }
      },
    );
  }



  @override
  Future<String> updateAvatar(File image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiEndpoints.baseUrl}/user/profile'),
      );
      // إضافة الهيدرز بدون Content-Type
      final token = await cacheService.getToken();
      final sessionCookie = await cacheService.getSessionCookie();
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'x-api-key': ApiEndpoints.api_key,
        if (sessionCookie != null) 'Cookie': sessionCookie,
      });
      // إضافة api_key كـ field
      request.fields['api_key'] = ApiEndpoints.api_key;
      // إضافة الصورة
      request.files.add(
        await http.MultipartFile.fromPath(
          'avatar_url', // تغيير اسم الحقل ليتطابق مع الباك إند
          image.path,
          contentType: MediaType('image', '*'), // السماح بأي نوع صورة
        ),
      );
      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          return jsonResponse['data']['avatar_url'];
        }
      }

      throw ServerException(
          message: 'فشل في رفع الصورة: ${response.statusCode}');
    } catch (e) {
      throw ServerException(message: 'حدث خطأ أثناء رفع الصورة');
    }
  }

  @override
  Future<ProfileModel> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();

        final response = await client.post(
          Uri.parse(ApiEndpoints.profile),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Cookie': sessionCookie ?? '',
          },
          body: jsonEncode({
            if (name != null) 'name': name,
            if (email != null) 'email': email,
            if (phone != null) 'phone': phone,
          }),
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          if (jsonResponse['success'] == true) {
            final profile = ProfileModel.fromJson(jsonResponse['data']);
            return profile;
          }
          throw ServerException(
            message: jsonResponse['message'] ?? 'فشل في تحديث البيانات الشخصية',
          );
        }

        throw ServerException(message: 'فشل في تحديث البيانات الشخصية');
      },
    );
  }

  @override
  Future<ProfileModel> updateAddress({
    required int cityId,
    required int stateId,
  }) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();

        final response = await client.post(
          Uri.parse(ApiEndpoints.profile),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Cookie': sessionCookie ?? '',
          },
          body: jsonEncode({
            'city_id': cityId,
            'state_id': stateId,
          }),
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          if (jsonResponse['success'] == true) {
            final profile = ProfileModel.fromJson(jsonResponse['data']);
            return profile;
          }
          throw ServerException(
            message: jsonResponse['message'] ?? 'فشل في تحديث العنوان',
          );
        }
        throw ServerException(message: 'فشل في تحديث العنوان');
      },
    );
  }

  @override
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();

        final response = await client.post(
          Uri.parse(ApiEndpoints.changePassword),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Cookie': sessionCookie ?? '',
          },
          body: jsonEncode({
            'current_password': currentPassword,
            'new_password': newPassword,
            'password_confirmation': confirmPassword,
          }),
        );

        final jsonResponse = json.decode(response.body);

        if (response.statusCode == 422) {
          // إذا كان هناك رسالة خطأ عامة (مثل كلمة المرور الحالية غير صحيحة)
          if (jsonResponse['message'] != null) {
            throw ValidationException(
              message: jsonResponse['message'],
              validationErrors: null,
            );
          }

          // إذا كان هناك أخطاء تحقق تفصيلية
          if (jsonResponse['errors'] != null) {
            final validationError = ChangePasswordValidationError.fromJson(
                jsonResponse['errors'] as Map<String, dynamic>);
            throw ValidationException(
              message: validationError.firstError ?? 'فشل في تغيير كلمة المرور',
              validationErrors: validationError,
            );
          }
        }

        if (response.statusCode == 200 && jsonResponse['success'] == true) {
          return jsonResponse['message'] ?? 'تم تغيير كلمة المرور بنجاح';
        }

        throw ServerException(
          message: jsonResponse['message'] ?? 'فشل في تغيير كلمة المرور',
        );
      },
    );
  }

  @override
  Future<bool> updateNotificationSettings({required bool enabled}) async {
    // TODO: Implement updateNotificationSettings
    throw UnimplementedException();
  }

  @override
  Future<String> verifyEmail() async {
    // TODO: Implement verifyEmail
    throw UnimplementedException();
  }

  @override
  Future<String> resendVerificationCode() async {
    // TODO: Implement resendVerificationCode
    throw UnimplementedException();
  }

  @override
  Future<String> deleteAccount({required String password}) async {
    // TODO: Implement deleteAccount
    throw UnimplementedException();
  }
}

class UnimplementedException implements Exception {
  final String message = 'هذه الخاصية غير متوفرة حالياً';
}
