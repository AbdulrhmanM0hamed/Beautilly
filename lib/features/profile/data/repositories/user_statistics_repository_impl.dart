import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../domain/entities/user_statistics.dart';
import '../../domain/repositories/user_statistics_repository.dart';
import '../datasources/user_statistics_remote_datasource.dart';

class UserStatisticsRepositoryImpl implements UserStatisticsRepository {
  final UserStatisticsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserStatisticsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserStatistics>> getUserStatistics() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final statistics = await remoteDataSource.getUserStatistics();
      return Right(statistics);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }
} 