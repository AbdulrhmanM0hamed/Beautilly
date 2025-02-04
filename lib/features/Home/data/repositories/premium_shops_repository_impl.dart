import 'package:beautilly/core/error/exceptions.dart';
import 'package:beautilly/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/premium_shop.dart';
import '../../domain/repositories/premium_shops_repository.dart';
import '../datasources/premium_shops_remote_data_source.dart';

class PremiumShopsRepositoryImpl implements PremiumShopsRepository {
  final PremiumShopsRemoteDataSource _remoteDataSource;

  PremiumShopsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<PremiumShop>>> getPremiumShops() async {
    try {
      final result = await _remoteDataSource.getPremiumShops();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
