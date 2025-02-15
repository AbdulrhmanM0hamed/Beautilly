import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/service_model.dart';

abstract class ServicesRemoteDataSource {
  Future<List<ServiceModel>> getServices();
  Future<List<ServiceModel>> searchServices(String query);
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;

  ServicesRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
  });

  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      final sessionCookie = await cacheService.getSessionCookie();

      final response = await client.get(
        Uri.parse(ApiEndpoints.services),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'x-api-key': ApiEndpoints.api_key,
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        if (decodedData['status'] == 'success') {
          final List<dynamic> data = decodedData['data'];
          return data.map((json) => ServiceModel.fromJson(json)).toList();
        } else {
          throw ServerException('فشل في تحميل الخدمات');
        }
      } else {
        throw ServerException('فشل في تحميل الخدمات');
      }
    } catch (e) {
      throw ServerException('حدث خطأ غير متوقع');
    }
  }

  @override
  Future<List<ServiceModel>> searchServices(String query) async {
    final token = await cacheService.getToken();
    final sessionCookie = await cacheService.getSessionCookie();

    try {
      final response = await client.get(
        Uri.parse(ApiEndpoints.searchServices(query)),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> servicesData = jsonResponse['data'];
          final services = servicesData
              .map((service) => ServiceModel.fromJson(service))
              .toList();
          return services;
        } else {
          throw ServerException(
              jsonResponse['message'] ?? 'فشل في تحميل نتائج البحث');
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
      } else {
        throw ServerException('فشل في تحميل نتائج البحث');
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      if (e is ServerException) rethrow;
      throw ServerException('حدث خطأ غير متوقع: $e');
    }
  }
}
