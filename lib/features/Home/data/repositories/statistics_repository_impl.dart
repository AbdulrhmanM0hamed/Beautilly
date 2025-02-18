import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/statistics_model.dart';
import '../../domain/repositories/statistics_repository.dart';
import 'package:beautilly/core/services/network/network_info.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final NetworkInfo networkInfo;
  final _statisticsController = StreamController<void>.broadcast();

  StatisticsRepositoryImpl({required this.networkInfo});

  Stream<void> get statisticsStream => _statisticsController.stream;

  @override
  Future<Either<Failure, StatisticsModel>> getStatistics() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

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
      
      return const Left(ServerFailure(message: 'فشل في تحميل الإحصائيات'));
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
