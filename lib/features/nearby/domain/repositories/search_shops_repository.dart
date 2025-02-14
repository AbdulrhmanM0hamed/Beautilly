import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/search_shop.dart';

abstract class SearchShopsRepository {
  Future<Either<Failure, List<SearchShop>>> searchShops({
    required String query,
    String? type,
  });
} 