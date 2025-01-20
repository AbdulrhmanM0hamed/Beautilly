import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, Map<String, dynamic>>> login(
      String email, String password);
  Future<Either<Failure, Map<String, dynamic>>> register(
      Map<String, dynamic> userData);
  Future<Either<Failure, String>> forgotPassword(String email);
  Future<Either<Failure, String>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  });
}
