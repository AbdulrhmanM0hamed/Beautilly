import 'dart:io';
import 'package:beautilly/core/services/network/network_info.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/search_shops_repository.dart';
import '../datasources/search_shops_remote_datasource.dart';

class SearchShopsRepositoryImpl implements SearchShopsRepository {
  final SearchShopsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SearchShopsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SearchShopsResponse>> filterShops({
    String? type,
    String? search,
    int page = 1,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
          message:
              'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'));
    }

    try {
      final result = await remoteDataSource.filterShops(
        type: type,
        search: search,
        page: page,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException catch (_) {
      return const Left(NetworkFailure(
          message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }
}
