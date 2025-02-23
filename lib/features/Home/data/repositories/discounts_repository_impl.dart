import 'dart:io';
import 'package:beautilly/core/error/exceptions.dart';
import 'package:beautilly/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:beautilly/core/services/network/network_info.dart';
import '../models/discount_model.dart';
import '../../domain/repositories/discounts_repository.dart';
import '../datasources/discounts_remote_data_source.dart';

class DiscountsRepositoryImpl implements DiscountsRepository {
  final DiscountsRemoteDataSource _remoteDataSource;
  final NetworkInfo networkInfo;

  DiscountsRepositoryImpl({
    required DiscountsRemoteDataSource remoteDataSource,
    required this.networkInfo,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, DiscountsResponse>> getDiscounts({int page = 1}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final result = await _remoteDataSource.getDiscounts(page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }
} 