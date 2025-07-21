import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';
import '../models/discount_model.dart';

abstract class DiscountsRemoteDataSource {
  Future<DiscountsResponse> getDiscounts({int page = 1});
}

class DiscountsRemoteDataSourceImpl
    with TokenRefreshMixin
    implements DiscountsRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;
  final AuthRepository authRepository;

  DiscountsRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
    required this.authRepository,
  });

  @override
  Future<DiscountsResponse> getDiscounts({int page = 1}) async {

    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        try {
          final sessionCookie = await cacheService.getSessionCookie();

          final uri = Uri.parse('${ApiEndpoints.discounts}?page=$page');

          final response = await client.get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'x-api-key': ApiEndpoints.apiKey,
              if (sessionCookie != null) 'Cookie': sessionCookie,
            },
          );

          if (response.statusCode == 200) {
            final decodedData = json.decode(response.body);
            final result = DiscountsResponse.fromJson(decodedData);

            return result;
          } else {
            throw ServerException(message: 'فشل في تحميل العروض');
          }
        } catch (e) {
          rethrow;
        }
      },
    );
  }
}
