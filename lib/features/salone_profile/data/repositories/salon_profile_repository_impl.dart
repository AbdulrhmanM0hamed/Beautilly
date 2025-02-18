import 'dart:io';
import 'package:beautilly/core/services/network/network_info.dart';
import 'package:beautilly/core/error/exceptions.dart';
import 'package:beautilly/core/error/failures.dart';
import 'package:beautilly/features/salone_profile/data/datasources/salon_profile_remote_data_source.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:beautilly/features/salone_profile/domain/repositories/salon_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:beautilly/features/salone_profile/data/models/rating_request_model.dart';

class SalonProfileRepositoryImpl implements SalonProfileRepository {
  final SalonProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SalonProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SalonProfile>> getSalonProfile(int salonId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final salonProfile = await remoteDataSource.getSalonProfile(salonId);
      return Right(salonProfile);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ أثناء تحميل بيانات الصالون'));
    }
  }

  @override
  Future<Either<Failure, void>> addShopRating(
    int shopId, 
    int rating, 
    String? comment,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      await remoteDataSource.addShopRating(
        shopId,
        RatingRequestModel(
          rating: rating,
          comment: comment,
        ),
      );
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteShopRating(int shopId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      await remoteDataSource.deleteShopRating(shopId);
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(int shopId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      await remoteDataSource.addToFavorites(shopId);
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(int shopId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      await remoteDataSource.removeFromFavorites(shopId);
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }
}
