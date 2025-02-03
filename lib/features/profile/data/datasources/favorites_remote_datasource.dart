import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../../domain/entities/favorite_shop.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<FavoriteShop>> getFavoriteShops();
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
  Future<List<FavoriteShop>> getFavoriteShops() async {
    try {
      final token = await cacheService.getToken();
      final sessionCookie = await cacheService.getSessionCookie();

      if (token == null) {
        throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
      }

      final response = await client.get(
        Uri.parse(ApiEndpoints.myFavoriteShops),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((shop) => FavoriteShop(
            id: shop['id'],
            name: shop['name'] as String,
            type: shop['type'] as String,
            image: shop['image'] as String,
            rating: shop['rating'].toString(),
            lovesCount: shop['loves_count'] as int,
          )).toList();
        } else {
          throw ServerException('فشل في تحميل المفضلة');
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
      } else {
        final error = json.decode(response.body);
        throw ServerException(error['message'] ?? 'فشل في تحميل المفضلة');
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
