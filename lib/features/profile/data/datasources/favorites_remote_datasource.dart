import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/favorite_shop.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<FavoriteShop>> getFavoriteShops();
  Future<void> addToFavorites(int shopId);
  Future<void> removeFromFavorites(int shopId);
}

class FavoritesRemoteDataSourceImpl with TokenRefreshMixin implements FavoritesRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;
  final AuthRepository authRepository;

  FavoritesRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
    required this.authRepository,
  });

  @override
  Future<List<FavoriteShop>> getFavoriteShops() async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();

        final response = await client.get(
          Uri.parse(ApiEndpoints.myFavoriteShops),
          headers: {
            'Authorization': 'Bearer $token',
            'x-api-key': ApiEndpoints.api_key,
            'Accept': 'application/json',
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
            throw ServerException(message: 'فشل في تحميل المفضلة');
          }
        } else {
          final error = json.decode(response.body);
          throw ServerException(message: error['message'] ?? 'فشل في تحميل المفضلة');
        }
      },
    );
  }

  @override
  Future<void> addToFavorites(int shopId) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();
        final response = await client.post(
          Uri.parse(ApiEndpoints.addToFavorites(shopId)),
          headers: {
            'Authorization': 'Bearer $token',
            'x-api-key': ApiEndpoints.api_key,
            'Accept': 'application/json',
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
        );

        if (response.statusCode != 200) {
          throw ServerException(message: 'فشل في إضافة المتجر للمفضلة');
        }
      },
    );
  }

  @override
  Future<void> removeFromFavorites(int shopId) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();
        final response = await client.delete(
          Uri.parse(ApiEndpoints.removeFromFavorites(shopId)),
          headers: {
            'Authorization': 'Bearer $token',
            'x-api-key': ApiEndpoints.api_key,
            'Accept': 'application/json',
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
        );

        if (response.statusCode != 200) {
          throw ServerException(message: 'فشل في إزالة المتجر من المفضلة');
        }
      },
    );
  }
}
