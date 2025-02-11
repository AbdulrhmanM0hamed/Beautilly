import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/salon_profile_repository.dart';

class AddToFavoritesUseCase {
  final SalonProfileRepository repository;

  AddToFavoritesUseCase(this.repository);

  Future<Either<Failure, void>> call(int shopId) {
    return repository.addToFavorites(shopId);
  }
} 