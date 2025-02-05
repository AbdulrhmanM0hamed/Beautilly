import 'package:beautilly/core/error/exceptions.dart';
import 'package:beautilly/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/discount.dart';
import '../../domain/repositories/discounts_repository.dart';
import '../datasources/discounts_remote_data_source.dart';

class DiscountsRepositoryImpl implements DiscountsRepository {
  final DiscountsRemoteDataSource _remoteDataSource;

  DiscountsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Discount>>> getDiscounts() async {
    try {
      final result = await _remoteDataSource.getDiscounts();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
} 