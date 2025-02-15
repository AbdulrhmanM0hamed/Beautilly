import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/search_shop_model.dart';

abstract class SearchShopsRemoteDataSource {
  Future<List<SearchShopModel>> searchShops({
    required String query,
    String? type,
  });
}

class SearchShopsRemoteDataSourceImpl implements SearchShopsRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;

  SearchShopsRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
  });

  @override
  Future<List<SearchShopModel>> searchShops({
    required String query,
    String? type,
  }) async {
    try {
      final token = await cacheService.getToken();
      final sessionCookie = await cacheService.getSessionCookie();

      final queryParams = {
        'search': query,
        if (type != null) 'type': type,
      };

      final response = await client.get(
        Uri.parse(ApiEndpoints.searchShops).replace(queryParameters: queryParams),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final shopsData = jsonResponse['data']['shops'] as List;
          return shopsData
              .map((shop) => SearchShopModel.fromJson(shop))
              .toList();
        } else {
          throw ServerException(
              jsonResponse['message'] ?? 'فشل في البحث عن المتاجر');
        }
      } else {
        throw ServerException('فشل في البحث عن المتاجر');
      }
    } catch (e) {
      throw ServerException('حدث خطأ غير متوقع');
    }
  }
} 