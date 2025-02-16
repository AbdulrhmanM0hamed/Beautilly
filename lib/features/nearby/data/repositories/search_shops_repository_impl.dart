
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/search_shop.dart';
import '../../domain/repositories/search_shops_repository.dart';
import '../datasources/search_shops_remote_datasource.dart';

class SearchShopsRepositoryImpl implements SearchShopsRepository {
  final SearchShopsRemoteDataSource remoteDataSource;

  SearchShopsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<SearchShop>>> filterShops({
    String? type,
    String? search,
  }) async {
    try {
      final shops = await remoteDataSource.filterShops(
        type: type,
        search: search,
      );
      return Right(shops);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
