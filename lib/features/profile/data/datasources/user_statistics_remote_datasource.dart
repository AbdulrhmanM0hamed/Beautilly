import 'dart:convert';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/user_statistics_model.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';

abstract class UserStatisticsRemoteDataSource {
  Future<UserStatisticsModel> getUserStatistics();
}

class UserStatisticsRemoteDataSourceImpl with TokenRefreshMixin implements UserStatisticsRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;
  final AuthRepository authRepository;

  UserStatisticsRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
    required this.authRepository,
  });

  @override
  Future<UserStatisticsModel> getUserStatistics() async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();
        
        final response = await client.get(
          Uri.parse(ApiEndpoints.userStatistics),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'x-api-key': ApiEndpoints.apiKey,
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success']) {
            return UserStatisticsModel.fromJson(data['data']);
          } else {
            throw ServerException(
              message: data['message'] ?? 'فشل في تحميل إحصائيات المستخدم'
            );
          }
        } else {
          throw ServerException(message: 'فشل في تحميل إحصائيات المستخدم');
        }
      },
    );
  }
}