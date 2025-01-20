import 'dart:convert';
import 'package:beautilly/core/utils/constant/api_endpoints.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, Map<String, dynamic>>> login(
    String email,
    String password,
  ) async {
    try {
      final uri = Uri.parse(ApiEndpoints.login);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Right({
          'user': UserModel.fromJson(data['user']),
          'token': data['token'] ?? '',
          'message': data['message'] ?? 'تم تسجيل الدخول بنجاح',
        });
      } else {
        final message = data['message'] ??
            (data['errors'] != null
                ? data['errors'].values.first.first
                : null) ??
            'فشل تسجيل الدخول';
        return Left(ServerFailure(message));
      }
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> register(
    Map<String, dynamic> userData,
  ) async {
    try {
      final uri = Uri.parse(ApiEndpoints.register);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(userData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return Right({
          'user': data['user'],
          'token': data['token'] ?? '',
          'message': data['message'] ?? 'تم التسجيل بنجاح',
        });
      } else {
        return Left(ServerFailure(data['message'] ?? 'حدث خطأ في التسجيل'));
      }
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }




  

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      final uri = Uri.parse(ApiEndpoints.forgotPassword);
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Right(data['status']);
      } else {
        final message = data['errors']?['email']?.first ?? 'حدث خطأ في إرسال رابط إعادة تعيين كلمة المرور';
        return Left(ServerFailure(message));
      }
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final uri = Uri.parse(ApiEndpoints.resetPassword);
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'token': token,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Right(data['status']);
      } else {
        final message = data['message'] ?? 'حدث خطأ في إعادة تعيين كلمة المرور';
        return Left(ServerFailure(message));
      }
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }
}
