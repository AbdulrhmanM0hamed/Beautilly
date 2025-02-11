import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/salon_profile_repository.dart';

class RemoveFromFavoritesUseCase {
  final SalonProfileRepository repository;

  RemoveFromFavoritesUseCase(this.repository);

  Future<Either<Failure, void>> call(int shopId) {
    return repository.removeFromFavorites(shopId);
  }
} 