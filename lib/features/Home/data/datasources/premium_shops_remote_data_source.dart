import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/premium_shop_model.dart';

abstract class PremiumShopsRemoteDataSource {
  Future<List<PremiumShopModel>> getPremiumShops();
}

class PremiumShopsRemoteDataSourceImpl implements PremiumShopsRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;

  PremiumShopsRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
  });

  @override
  Future<List<PremiumShopModel>> getPremiumShops() async {
    try {
      final sessionCookie = await cacheService.getSessionCookie();
      
      final response = await client.get(
        Uri.parse(ApiEndpoints.premiumShops),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'x-api-key': ApiEndpoints.api_key,
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (decodedData['success']) {
          final List<dynamic> shops = decodedData['data']['shops'];
          return shops.map((json) => PremiumShopModel.fromJson(json)).toList();
        } else {
          throw ServerException(decodedData['message'] ?? 'فشل في تحميل المتاجر المميزة');
        }
      } else {
        throw ServerException('فشل في تحميل المتاجر المميزة');
      }
    } catch (e) {
      throw ServerException('حدث خطأ غير متوقع');
    }
  }
}
