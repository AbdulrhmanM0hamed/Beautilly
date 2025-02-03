import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/service_model.dart';

abstract class ServicesRemoteDataSource {
  Future<List<ServiceModel>> getServices();
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
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        throw ServerException('فشل في تحميل الخدمات');
      }
    } catch (e) {
      throw ServerException('حدث خطأ غير متوقع');
    }
  }
} 