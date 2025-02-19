import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

  SearchShopsResponse.fromJson(Map<String, dynamic> json)
      : shops = List<SearchShopModel>.from(json['shops'].map((x) => SearchShopModel.fromJson(x))),
        pagination = PaginationModel.fromJson(json['pagination']);
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
      final token = await cacheService.getToken();

      final url = ApiEndpoints.filterShops(
        type: type,
        search: search,
        page: page,
      );

      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return SearchShopsResponse.fromJson(data['data']);
        }
        throw ServerException(message:  data['message'] ?? 'حدث خطأ في الخادم');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException( 'يرجى تسجيل الدخول');
      } else {
        throw ServerException(message: 'حدث خطأ في الخادم');
      }
    } on SocketException {
      throw  ServerException(message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت');
    } on TimeoutException {
      throw  ServerException(message: 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى');
    } catch (e) {
      throw  ServerException(message: 'حدث خطأ غير متوقع');
    }
  }
}
