import 'package:beautilly/core/error/exceptions.dart';
import 'package:beautilly/core/error/failures.dart';
import 'package:beautilly/features/salone_profile/data/datasources/salon_profile_remote_data_source.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:beautilly/features/salone_profile/domain/repositories/salon_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:beautilly/features/salone_profile/data/models/rating_request_model.dart';

class SalonProfileRepositoryImpl implements SalonProfileRepository {
  final SalonProfileRemoteDataSource remoteDataSource;

  SalonProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, SalonProfile>> getSalonProfile(int salonId) async {
    try {
      final salonProfile = await remoteDataSource.getSalonProfile(salonId);
      return Right(salonProfile);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ أثناء تحميل بيانات الصالون'));
    }
  }

  @override
  Future<Either<Failure, void>> addShopRating(
    int shopId, 
    int rating, 
    String? comment,
  ) async {
    try {
      await remoteDataSource.addShopRating(
        shopId,
        RatingRequestModel(
          rating: rating,
          comment: comment,
        ),
      );
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }
}
