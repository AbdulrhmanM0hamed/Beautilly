import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_statistics.dart';

abstract class UserStatisticsRepository {
  Future<Either<Failure, UserStatistics>> getUserStatistics();
}
