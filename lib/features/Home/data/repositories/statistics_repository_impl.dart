import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/statistics_model.dart';
import '../../domain/repositories/statistics_repository.dart';
import 'package:beautilly/core/services/network/network_info.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';

class StatisticsRepositoryImpl with TokenRefreshMixin implements StatisticsRepository {
  final NetworkInfo networkInfo;
  final http.Client client;
  final CacheService cacheService;
  final AuthRepository authRepository;
  final _statisticsController = StreamController<void>.broadcast();

  StatisticsRepositoryImpl({
    required this.networkInfo,
    required this.client,
    required this.cacheService,
    required this.authRepository,
  });

  Stream<void> get statisticsStream => _statisticsController.stream;

  @override
  Future<Either<Failure, StatisticsModel>> getStatistics() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      return await withTokenRefresh(
        authRepository: authRepository,
        cacheService: cacheService,
        request: (token) async {
          final sessionCookie = await cacheService.getSessionCookie();
          
          final response = await client.get(
            Uri.parse(ApiEndpoints.statistics),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'x-api-key': ApiEndpoints.api_key,
              if (sessionCookie != null) 'Cookie': sessionCookie,
            },
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['success'] == true) {
              return Right(StatisticsModel.fromJson(data['data']));
            }
          }
          
          return const Left(ServerFailure(message: 'فشل في تحميل الإحصائيات'));
        },
      );
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  void dispose() {
    _statisticsController.close();
  }
}
