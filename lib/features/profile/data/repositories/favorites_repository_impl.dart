import 'dart:io';
import 'package:beautilly/core/services/network/network_info.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';
import '../../domain/entities/favorite_shop.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FavoritesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<FavoriteShop>>> getFavoriteShops() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final favorites = await remoteDataSource.getFavoriteShops();
      return Right(favorites);
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

  // @override
  // Future<Either<Failure, void>> toggleFavorite(int shopId) async {
  //   try {
  //     await remoteDataSource.toggleFavorite(shopId);
  //     return const Right(null);
  //   } on UnauthorizedException catch (e) {
  //     return Left(AuthFailure(e.message));
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message));
  //   } catch (e) {
  //     return const Left(ServerFailure('حدث خطأ غير متوقع'));
  //   }
  // }
} 