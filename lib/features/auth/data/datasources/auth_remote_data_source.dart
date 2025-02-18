import 'dart:convert';

import 'package:beautilly/core/error/exceptions.dart';
import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/core/utils/constant/api_endpoints.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<String> refreshToken();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
  });

  @override
  Future<String> refreshToken() async {
    final refreshToken = await cacheService.getRefreshToken();
    if (refreshToken == null) {
      throw UnauthorizedException('يرجى إعادة تسجيل الدخول');
    }

    try {
      final response = await client.post(
        Uri.parse(ApiEndpoints.refreshToken),
        headers: {
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final newAccessToken = json['access_token'];
        
        await cacheService.saveToken(newAccessToken);
        return newAccessToken;
      } else {
        throw ServerException(message: 'فشل في تجديد الجلسة');
      }
    } catch (e) {
      throw ServerException(message: 'حدث خطأ في الاتصال بالخادم');
    }
  }
}
