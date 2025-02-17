import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/search_shop_model.dart';

class SearchShopsResponse {
  final List<SearchShopModel> shops;
  final PaginationModel pagination;

  SearchShopsResponse({
    required this.shops,
    required this.pagination,
  });
}

abstract class SearchShopsRemoteDataSource {
  Future<SearchShopsResponse> filterShops({
    String? type,
    String? search,
    int page = 1,
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
  Future<SearchShopsResponse> filterShops({
    String? type,
    String? search,
    int page = 1,
  }) async {
    try {
      final sessionCookie = await cacheService.getSessionCookie();
      final token = await cacheService.getToken();

      final url = ApiEndpoints.filterShops(
        type: type,
        search: search,
        page: page,
      );

      final response = await client.get(
        Uri.parse(url),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final List<dynamic> shopsData = data['data']['shops'] as List;
          final paginationData = data['data']['pagination'];

          return SearchShopsResponse(
            shops: shopsData
                .map((shop) => SearchShopModel.fromJson(shop))
                .toList(),
            pagination: PaginationModel.fromJson(paginationData),
          );
        } else {
          throw ServerException('لا توجد نتائج');
        }
      } else {
        final error = json.decode(response.body);
        throw ServerException(error['message'] ?? 'حدث خطأ في البحث');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
