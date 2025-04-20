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
      : shops = List<SearchShopModel>.from(
            json['shops'].map((x) => SearchShopModel.fromJson(x))),
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
      final session = await cacheService.getSessionCookie();

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
          'Content-Type': 'application/json',
          'Cookie': session ?? '',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
      //  print(data);

        if (data['success'] == true) {
          final responseData = data['data'] as Map<String, dynamic>;
          final result = SearchShopsResponse(
            shops: List<SearchShopModel>.from(
                responseData['shops'].map((x) => SearchShopModel.fromJson(x))),
            pagination: PaginationModel.fromJson(responseData['pagination']),
          );

          return result;
        }

        final errorMessage = data['message'] ?? 'حدث خطأ في الخادم';
        throw ServerException(message: errorMessage);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('يرجى تسجيل الدخول');
      } else {
        throw ServerException(message: 'حدث خطأ في الخادم');
      }
    } on SocketException catch (e) {
      throw ServerException(
          message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت');
    } on TimeoutException catch (e) {
      throw ServerException(
          message: 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى');
    } catch (e) {
      throw ServerException(message: 'حدث خطأ غير متوقع: $e');
    }
  }
}
