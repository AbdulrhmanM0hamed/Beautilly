import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/premium_shop.dart';

abstract class PremiumShopsRepository {
  Future<Either<Failure, List<PremiumShop>>> getPremiumShops({required int page});
} 