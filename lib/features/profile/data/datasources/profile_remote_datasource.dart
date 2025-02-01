import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/profile_model.dart';

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
    //   required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
  Future<bool> updateNotificationSettings({required bool enabled});
  Future<String> verifyEmail();
  Future<String> resendVerificationCode();
  Future<String> deleteAccount({required String password});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;

  ProfileRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
  });

  Future<Map<String, String>> _getHeaders() async {
    final token = await cacheService.getToken();
    final sessionCookie = await cacheService.getSessionCookie();

    if (token == null) {
      throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
    }

    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'x-api-key': ApiEndpoints.api_key,
      if (sessionCookie != null) 'Cookie': sessionCookie,
    };
  }

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await client.get(
        Uri.parse(ApiEndpoints.profile),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          return ProfileModel.fromJson(jsonResponse['data']);
        } else {
          throw ServerException(
            jsonResponse['message'] ?? 'فشل في تحميل بيانات الملف الشخصي',
          );
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
      } else {
        throw ServerException('فشل في تحميل بيانات الملف الشخصي');
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      if (e is ServerException) rethrow;
      throw ServerException('حدث خطأ غير متوقع');
    }
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

      throw ServerException('فشل في رفع الصورة: ${response.statusCode}');
    } catch (e) {
      throw ServerException('حدث خطأ أثناء رفع الصورة');
    }
  }

  @override
  Future<ProfileModel> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(ApiEndpoints.profile),
        headers: await _getHeaders(),
        body: jsonEncode({
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          return ProfileModel.fromJson(jsonResponse['data']);
        } else {
          throw ServerException(
            jsonResponse['message'] ?? 'فشل في تحديث البيانات الشخصية',
          );
        }
      } else {
        throw ServerException('فشل في تحديث البيانات الشخصية');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('حدث خطأ أثناء تحديث البيانات');
    }
  }

  @override
  Future<ProfileModel> updateAddress({
    required int cityId,
    required int stateId,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(ApiEndpoints.updateProfile),
        headers: await _getHeaders(),
        body: jsonEncode({
          'city_id': cityId,
          'state_id': stateId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          return ProfileModel.fromJson(jsonResponse['data']);
        } else {
          throw ServerException(
            jsonResponse['message'] ?? 'فشل في تحديث العنوان',
          );
        }
      } else {
        throw ServerException('فشل في تحديث العنوان');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('حدث خطأ أثناء تحديث العنوان');
    }
  }

  @override
  Future<String> changePassword({
    //   required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiEndpoints.baseUrl}/user/profile'),
        headers: await _getHeaders(),
        body: jsonEncode({
          //      'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          return jsonResponse['message'] ?? 'تم تغيير كلمة المرور بنجاح';
        }
        throw ServerException(
            jsonResponse['message'] ?? 'فشل في تغيير كلمة المرور');
      }

      throw ServerException('فشل في تغيير كلمة المرور');
    } catch (e) {
      throw ServerException('حدث خطأ أثناء تغيير كلمة المرور');
    }
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
