import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/favorite_shop_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<FavoriteShopModel>> getFavoriteShops();
  Future<void> addToFavorites(int shopId);
  Future<void> removeFromFavorites(int shopId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;

  FavoritesRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
  });

  @override
  Future<List<FavoriteShopModel>> getFavoriteShops() async {
    final token = await cacheService.getToken();
    final sessionCookie = await cacheService.getSessionCookie();

    if (token == null) {
      throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
    }

    try {
      final response = await client.get(
        Uri.parse(ApiEndpoints.myFavoriteShops),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          return (jsonResponse['data'] as List)
              .map((shop) => FavoriteShopModel.fromJson(shop))
              .toList();
        } else {
          throw ServerException(jsonResponse['message'] ?? 'حدث خطأ في تحميل المفضلة');
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
      } else {
        throw ServerException('فشل في تحميل المفضلة');
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      if (e is ServerException) rethrow;
      throw ServerException('حدث خطأ غير متوقع');
    }
  }

  @override
  Future<void> addToFavorites(int shopId) async {
    // Implementation for adding to favorites
  }

  @override
  Future<void> removeFromFavorites(int shopId) async {
    // Implementation for removing from favorites
  }
} 