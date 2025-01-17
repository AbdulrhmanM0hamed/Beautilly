import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/statistics_model.dart';
import '../../domain/repositories/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  @override
  Future<Either<Failure, StatisticsModel>> getStatistics() async {
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.statistics),
        headers: {
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return Right(StatisticsModel.fromJson(data['data']));
      } else {
        return const Left(ServerFailure('فشل في تحميل الإحصائيات'));
      }
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }
}
