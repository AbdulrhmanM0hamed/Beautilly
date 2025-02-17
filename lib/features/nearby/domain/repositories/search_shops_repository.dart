import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/search_shops_remote_datasource.dart';

abstract class SearchShopsRepository {
  Future<Either<Failure, SearchShopsResponse>> filterShops({
    String? type,
    String? search,
    int page = 1,
  });
}
