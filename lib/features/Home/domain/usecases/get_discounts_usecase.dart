import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/discount.dart';
import '../repositories/discounts_repository.dart';

class GetDiscountsUseCase implements UseCase<List<Discount>, NoParams> {
  final DiscountsRepository repository;

  GetDiscountsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Discount>>> call(NoParams params) {
    return repository.getDiscounts();
  }
} 