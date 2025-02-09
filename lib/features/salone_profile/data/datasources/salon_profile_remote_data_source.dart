import 'dart:convert';
import 'dart:io';
import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:http/http.dart' as http;
import 'package:beautilly/core/error/exceptions.dart';
import 'package:beautilly/core/utils/constant/api_endpoints.dart';
import 'package:beautilly/features/salone_profile/data/models/salon_profile_model.dart';

abstract class SalonProfileRemoteDataSource {
  Future<SalonProfileModel> getSalonProfile(int salonId);
}

class SalonProfileRemoteDataSourceImpl implements SalonProfileRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;

  SalonProfileRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
  });

  @override
  Future<SalonProfileModel> getSalonProfile(int salonId) async {
    try {
      final token = await cacheService.getToken();
      final sessionCookie = await cacheService.getSessionCookie();

      if (token == null) {
        throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
      }

      final response = await client.get(
        Uri.parse(ApiEndpoints.shopProfile(salonId)),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          return SalonProfileModel.fromJson(jsonResponse['data']);
        } else {
          throw ServerException(
            jsonResponse['message'] ?? 'فشل في تحميل بيانات الصالون',
          );
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
          'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول',
        );
      } else {
        final error = json.decode(response.body);
        throw ServerException(
          error['message'] ?? 'فشل في تحميل بيانات الصالون',
        );
      }
    } catch (e) {
      throw ServerException('حدث خطأ غير متوقع: $e');
    }
  }
} 