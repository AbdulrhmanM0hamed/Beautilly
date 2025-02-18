import 'dart:io';
import 'package:beautilly/core/error/exceptions.dart';
import 'package:beautilly/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:beautilly/core/services/network/network_info.dart';
import '../../domain/entities/premium_shop.dart';
import '../../domain/repositories/premium_shops_repository.dart';
import '../datasources/premium_shops_remote_data_source.dart';

class PremiumShopsRepositoryImpl implements PremiumShopsRepository {
  final PremiumShopsRemoteDataSource _remoteDataSource;
  final NetworkInfo networkInfo;

  PremiumShopsRepositoryImpl({
    required PremiumShopsRemoteDataSource remoteDataSource,
    required this.networkInfo,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<PremiumShop>>> getPremiumShops() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final result = await _remoteDataSource.getPremiumShops();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return  const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }
}
