import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';
import '../models/premium_shop_model.dart';

abstract class PremiumShopsRemoteDataSource {
  Future<List<PremiumShopModel>> getPremiumShops({required int page});
}

class PremiumShopsRemoteDataSourceImpl
    with TokenRefreshMixin
    implements PremiumShopsRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;
  final AuthRepository authRepository;

  PremiumShopsRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
    required this.authRepository,
  });

  @override
  Future<List<PremiumShopModel>> getPremiumShops({required int page}) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();

        final response = await client.get(
          Uri.parse('${ApiEndpoints.premiumShops}?page=$page'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'x-api-key': ApiEndpoints.apiKey,
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
        );

        if (response.statusCode == 200) {
          final decodedData = json.decode(response.body);
          if (decodedData['success']) {
            final List<dynamic> shops = decodedData['data']['shops'];
            final pagination = decodedData['data']['pagination'];
            return shops
                .map((json) => PremiumShopModel.fromJson({
                      ...json,
                      'pagination': pagination,
                    }))
                .toList();
          }
          throw ServerException(
              message:
                  decodedData['message'] ?? 'فشل في تحميل المتاجر المميزة');
        }
        throw ServerException(message: 'فشل في تحميل المتاجر المميزة');
      },
    );
  }
}
