import 'package:beautilly/features/booking/domain/entities/available_time.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> bookService({
    required int shopId,
    required int serviceId,
    required int dayId,
    required int timeId,
  }) async {
    try {
      await remoteDataSource.bookService(
        shopId: shopId,
        serviceId: serviceId,
        dayId: dayId,
        timeId: timeId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> bookDiscount({
    required int shopId,
    required int discountId,
    required int dayId,
    required int timeId,
  }) async {
    try {
      await remoteDataSource.bookDiscount(
        shopId: shopId,
        discountId: discountId,
        dayId: dayId,
        timeId: timeId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<AvailableDate>>> getAvailableDates(int shopId) async {
    try {
      final dates = await remoteDataSource.getAvailableDates(shopId);
      return Right(dates);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  // باقي التنفيذ مشابه
} 