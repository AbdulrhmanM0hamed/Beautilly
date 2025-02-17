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
  Future<Either<Failure, SearchShopsResponse>> filterShops({
    String? type,
    String? search,
    int page = 1,
  }) async {
    try {
      final result = await remoteDataSource.filterShops(
        type: type,
        search: search,
        page: page,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
