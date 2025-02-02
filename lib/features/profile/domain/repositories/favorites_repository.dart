import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/favorite_shop.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<FavoriteShop>>> getFavoriteShops();
 // Future<Either<Failure, void>> addToFavorites(int shopId);
 // Future<Either<Failure, void>> removeFromFavorites(int shopId);

} 