import 'dart:convert';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../models/search_result_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchResultModel>> searchShops({required String query});
}

class SearchRemoteDataSourceImpl
    with TokenRefreshMixin
    implements SearchRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;
  final AuthRepository authRepository;

  SearchRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
    required this.authRepository,
  });

  @override
  Future<List<SearchResultModel>> searchShops({required String query}) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();

        final response = await client.get(
          Uri.parse('${ApiEndpoints.searchShops}?search=$query'),
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
            return shops
                .map((json) => SearchResultModel.fromJson(json))
                .toList();
          }
          throw ServerException(
              message: decodedData['message'] ?? 'فشل في البحث عن المتاجر');
        }
        throw ServerException(message: 'فشل في البحث عن المتاجر');
      },
    );
  }
}
