import 'dart:io';
import 'package:beautilly/core/services/network/network_info.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, String>> updateAvatar(File image) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final imageUrl = await remoteDataSource.updateAvatar(image);
      return Right(imageUrl);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'فشل في تحديث الصورة الشخصية'));
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final profile = await remoteDataSource.updateProfile(
        name: name,
        email: email,
        phone: phone,
      );
      return Right(profile);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'فشل في تحديث البيانات الشخصية'));
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> updateAddress({
    required int cityId,
    required int stateId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }
    try {
      final profile = await remoteDataSource.updateAddress(
        cityId: cityId,
        stateId: stateId,
      );
      return Right(profile);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'فشل في تحديث العنوان'));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final message = await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return Right(message);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        message: e.message,
        validationErrors: e.validationErrors,
      ));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'فشل في تغيير كلمة المرور'));
    }
  }

  @override
  Future<Either<Failure, bool>> updateNotificationSettings({
    required bool enabled
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final result = await remoteDataSource.updateNotificationSettings(enabled: enabled);
      return Right(result);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, String>> verifyEmail() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final result = await remoteDataSource.verifyEmail();
      return Right(result);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, String>> resendVerificationCode() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final result = await remoteDataSource.resendVerificationCode();
      return Right(result);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteAccount({required String password}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final result = await remoteDataSource.deleteAccount(password: password);
      return Right(result);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  // ... باقي التنفيذات للوظائف الأخرى
}
