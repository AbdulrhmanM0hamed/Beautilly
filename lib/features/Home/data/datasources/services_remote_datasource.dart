import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';
import '../models/service_model.dart';

abstract class ServicesRemoteDataSource {
  Future<ServicesResponse> getServices({int page = 1});
  Future<List<ServiceModel>> searchServices(String query);
}

class ServicesRemoteDataSourceImpl
    with TokenRefreshMixin
    implements ServicesRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;
  final AuthRepository authRepository;

  ServicesRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
    required this.authRepository,
  });

  @override
  Future<ServicesResponse> getServices({int page = 1}) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        try {
          final sessionCookie = await cacheService.getSessionCookie();
          
          final queryParameters = {
            'page': page.toString(),
          };

          final uri = Uri.parse(ApiEndpoints.services).replace(
            queryParameters: queryParameters,
          );
          
          final response = await client.get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'x-api-key': ApiEndpoints.api_key,
              if (sessionCookie != null) 'Cookie': sessionCookie,
            },
          );

          if (response.statusCode == 200) {
            final decodedData = json.decode(response.body);
            
            if (decodedData['status'] == 'success' && decodedData['data'] != null) {
              return ServicesResponse.fromJson(decodedData);
            } else {
              throw ServerException(
                message: decodedData['message'] ?? 'فشل في تحميل الخدمات'
              );
            }
          } else {
            throw ServerException(message: 'فشل في تحميل الخدمات');
          }
        } catch (e) {
          throw ServerException(
            message: 'حدث خطأ في تحميل الخدمات، يرجى المحاولة مرة أخرى'
          );
        }
      },
    );
  }

  @override
  Future<List<ServiceModel>> searchServices(String query) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();

        final response = await client.get(
          Uri.parse(ApiEndpoints.searchServices(query)),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'x-api-key': ApiEndpoints.api_key,
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          if (jsonResponse['status'] == 'success') {
            final List<dynamic> servicesData = jsonResponse['data'];
            return servicesData
                .map((service) => ServiceModel.fromJson(service))
                .toList();
          } else {
            throw ServerException(
                message: jsonResponse['message'] ?? 'فشل في تحميل نتائج البحث');
          }
        } else {
          throw ServerException(message: 'فشل في تحميل نتائج البحث');
        }
      },
    );
  }
}
