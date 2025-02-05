import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/discount.dart';

abstract class DiscountsRepository {
  Future<Either<Failure, List<Discount>>> getDiscounts();
} 