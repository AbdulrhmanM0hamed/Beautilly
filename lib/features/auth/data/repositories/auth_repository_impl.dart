import 'dart:convert';
import 'package:beautilly/core/utils/constant/api_endpoints.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
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
          'Authorization': 'Bearer ${ApiEndpoints.api_key}',
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
          'token': data['token'],
          'message': data['message'],
        });
      } else {
        return Left(
            ServerFailure(data['message'] ?? AuthExceptions.loginFailed));
      }
    } catch (e) {
      return const Left(ServerFailure(AuthExceptions.unknownError));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> register(
      Map<String, dynamic> userData) async {
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
    if (response.statusCode == 200) {
      return Right({
        'user': UserModel.fromJson(data['user']),
        'token': data['token'],
        'message': data['message'],
      });
    } else {
      return Left(
          ServerFailure(data['message'] ?? AuthExceptions.registerFailed));
    }
  }
}
