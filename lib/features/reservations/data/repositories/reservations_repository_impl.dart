import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/reservation.dart';
import '../../domain/repositories/reservations_repository.dart';
import '../datasources/reservations_remote_datasource.dart';

class ReservationsRepositoryImpl implements ReservationsRepository {
  final ReservationsRemoteDataSource remoteDataSource;

  ReservationsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ReservationEntity>>> getMyReservations() async {
    try {
      final reservations = await remoteDataSource.getMyReservations();
      return Right(reservations);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }
} 