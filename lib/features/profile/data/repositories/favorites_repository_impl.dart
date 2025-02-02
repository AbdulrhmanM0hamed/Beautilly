import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';
import '../../domain/entities/favorite_shop.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<FavoriteShop>>> getFavoriteShops() async {
    try {
      final favorites = await remoteDataSource.getFavoriteShops();
      return Right(favorites);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
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