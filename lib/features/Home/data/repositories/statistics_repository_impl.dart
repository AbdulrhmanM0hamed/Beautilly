import 'dart:convert';
import 'dart:async';
import 'package:beautilly/core/services/cache/shared_preferences_service.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/statistics_model.dart';
import '../../domain/repositories/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final _statisticsController = StreamController<void>.broadcast();

  StatisticsRepositoryImpl();


  Stream<void> get statisticsStream => _statisticsController.stream;

  @override
  Future<Either<Failure, StatisticsModel>> getStatistics() async {
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.statistics),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return Right(StatisticsModel.fromJson(data['data']));
        }
      }
      
      return const Left(ServerFailure('فشل في تحميل الإحصائيات'));
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }

  void dispose() {
    _statisticsController.close();
  }
}
