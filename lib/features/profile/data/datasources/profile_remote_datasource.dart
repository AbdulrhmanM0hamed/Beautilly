import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;

  ProfileRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
  });

  @override
  Future<ProfileModel> getProfile() async {
    final token = await cacheService.getToken();
    final sessionCookie = await cacheService.getSessionCookie();

    if (token == null) {
      throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
    }

    try {
      final response = await client.get(
        Uri.parse(ApiEndpoints.profile),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'x-api-key': ApiEndpoints.api_key,
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
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
        throw UnauthorizedException('انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
      } else {
        throw ServerException('فشل في تحميل بيانات الملف الشخصي');
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      if (e is ServerException) rethrow;
      throw ServerException('حدث خطأ غير متوقع');
    }
  }
} 