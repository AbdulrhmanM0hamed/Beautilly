import 'package:dartz/dartz.dart';
import 'package:beautilly/core/error/failures.dart';
import '../entities/salon_profile.dart';

abstract class SalonProfileRepository {
  Future<Either<Failure, SalonProfile>> getSalonProfile(int salonId);
  Future<Either<Failure, void>> addShopRating(int shopId, int rating, String? comment);
  Future<Either<Failure, void>> deleteShopRating(int shopId);
  Future<Either<Failure, void>> addToFavorites(int shopId);
  Future<Either<Failure, void>> removeFromFavorites(int shopId);
} 