import 'package:beautilly/core/error/failures.dart';
import 'package:beautilly/features/salone_profile/domain/repositories/salon_profile_repository.dart';
import 'package:dartz/dartz.dart';

class AddShopRatingUseCase {
  final SalonProfileRepository repository;

  AddShopRatingUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int shopId,
    required int rating,
    String? comment,
  }) {
    return repository.addShopRating(shopId, rating, comment);
  }
} 