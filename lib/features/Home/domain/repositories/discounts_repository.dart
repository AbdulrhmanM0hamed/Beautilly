import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/discount_model.dart';

abstract class DiscountsRepository {
  Future<Either<Failure, DiscountsResponse>> getDiscounts({int page = 1});
} 