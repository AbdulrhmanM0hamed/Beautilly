import 'dart:io';
import 'package:beautilly/core/services/network/network_info.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/reservation.dart';
import '../../domain/repositories/reservations_repository.dart';
import '../datasources/reservations_remote_datasource.dart';

class ReservationsRepositoryImpl implements ReservationsRepository {
  final ReservationsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ReservationsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ReservationEntity>>> getMyReservations() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final reservations = await remoteDataSource.getMyReservations();
      return Right(reservations);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return  const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return  const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }
} 