import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/salon_profile_repository.dart';

class DeleteShopRatingUseCase {
  final SalonProfileRepository repository;

  DeleteShopRatingUseCase(this.repository);

  Future<Either<Failure, void>> call(int shopId) {
    return repository.deleteShopRating(shopId);
  }
} 