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

class DiscountsRemoteDataSourceImpl with TokenRefreshMixin implements DiscountsRemoteDataSource {
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
    print('📱 Fetching discounts for page: $page');
    
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        try {
          final sessionCookie = await cacheService.getSessionCookie();
          
          final uri = Uri.parse('${ApiEndpoints.discounts}?page=$page');
          print('🌐 Request URL: $uri');
          
          final response = await client.get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'x-api-key': ApiEndpoints.api_key,
              if (sessionCookie != null) 'Cookie': sessionCookie,
            },
          );

          print('📥 Response status: ${response.statusCode}');
          print('📦 Response body: ${response.body}');

          if (response.statusCode == 200) {
            final decodedData = json.decode(response.body);
            final result = DiscountsResponse.fromJson(decodedData);
            print('✅ Loaded ${result.discounts.length} discounts');
            print('📊 Pagination: Page ${result.pagination.currentPage}/${result.pagination.lastPage}');
            return result;
          } else {
            print('❌ Failed to load discounts: ${response.body}');
            throw ServerException(message: 'فشل في تحميل العروض');
          }
        } catch (e, stackTrace) {
          print('💥 Error loading discounts: $e');
          print('Stack trace: $stackTrace');
          rethrow;
        }
      },
    );
  }
} 