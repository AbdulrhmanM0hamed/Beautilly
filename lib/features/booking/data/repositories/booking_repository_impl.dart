import 'dart:io';
import 'package:beautilly/core/services/network/network_info.dart';
import 'package:beautilly/features/booking/domain/entities/available_time.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> bookService({
    required int shopId,
    required int serviceId,
    required int dayId,
    required int timeId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'));
    }

    try {
      await remoteDataSource.bookService(
        shopId: shopId,
        serviceId: serviceId,
        dayId: dayId,
        timeId: timeId,
      );
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on SocketException {
      return Left(NetworkFailure(message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'));
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, void>> bookDiscount({
    required int shopId,
    required int discountId,
    required int dayId,
    required int timeId,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'));
    }

    try {
      await remoteDataSource.bookDiscount(
        shopId: shopId,
        discountId: discountId,
        dayId: dayId,
        timeId: timeId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on SocketException {
      return Left(NetworkFailure(message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'));
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, List<AvailableDate>>> getAvailableDates(int shopId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'));
    }

    try {
      final dates = await remoteDataSource.getAvailableDates(shopId);
      return Right(dates);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on SocketException {
      return Left(NetworkFailure(message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'));
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment(int appointmentId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'));
    }

    try {
      await remoteDataSource.cancelAppointment(appointmentId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on SocketException {
      return Left(NetworkFailure(message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'));
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  // باقي التنفيذ مشابه
} 