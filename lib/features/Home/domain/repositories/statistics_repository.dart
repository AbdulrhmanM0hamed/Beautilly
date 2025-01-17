import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/statistics_model.dart';

abstract class StatisticsRepository {
  Future<Either<Failure, StatisticsModel>> getStatistics();
}
