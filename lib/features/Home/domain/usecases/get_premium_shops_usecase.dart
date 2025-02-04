import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/premium_shop.dart';
import '../repositories/premium_shops_repository.dart';

class GetPremiumShopsUseCase {
  final PremiumShopsRepository repository;

  GetPremiumShopsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PremiumShop>>> call(NoParams params) {
    return repository.getPremiumShops();
  }
} 