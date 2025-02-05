import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/discount_model.dart';

abstract class DiscountsRemoteDataSource {
  Future<List<DiscountModel>> getDiscounts();
}

class DiscountsRemoteDataSourceImpl implements DiscountsRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;

  DiscountsRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
  });

  @override
  Future<List<DiscountModel>> getDiscounts() async {
    try {
      final sessionCookie = await cacheService.getSessionCookie();
      
      final response = await client.get(
        Uri.parse(ApiEndpoints.discounts),
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
          final List<dynamic> discounts = decodedData['data']['discounts'];
          return discounts.map((json) => DiscountModel.fromJson(json)).toList();
        } else {
          throw ServerException(decodedData['message'] ?? 'فشل في تحميل العروض');
        }
      } else {
        throw ServerException('فشل في تحميل العروض');
      }
    } catch (e) {
      throw ServerException('حدث خطأ غير متوقع');
    }
  }
} 