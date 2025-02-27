import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/premium_shop.dart';
import '../repositories/premium_shops_repository.dart';

class GetPremiumShopsUseCase {
  final PremiumShopsRepository repository;

  GetPremiumShopsUseCase(this.repository);

  Future<Either<Failure, List<PremiumShop>>> call(int page) {
    return repository.getPremiumShops(page: page);
  }
} 