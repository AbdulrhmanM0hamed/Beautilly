import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/discount.dart';
import '../repositories/discounts_repository.dart';
import '../../data/models/discount_model.dart';

class GetDiscountsUseCase implements UseCase<DiscountsResponse, int> {
  final DiscountsRepository repository;

  GetDiscountsUseCase(this.repository);

  @override
  Future<Either<Failure, DiscountsResponse>> call(int page) {
    return repository.getDiscounts(page: page);
  }
} 