import 'dart:convert';
import 'dart:io';
import 'package:beautilly/core/error/exceptions.dart';
import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/core/utils/constant/api_endpoints.dart';
import 'package:beautilly/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import 'package:beautilly/core/services/network/network_info.dart';

class AuthRepositoryImpl implements AuthRepository {
  final CacheService _cacheService;
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(
    this._cacheService,
    this.remoteDataSource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, Map<String, dynamic>>> login(
    String emailOrPhone,
    String password,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.login),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'x-api-key': ApiEndpoints.api_key,
        },
        body: jsonEncode({
          emailOrPhone.contains('@') ? 'email' : 'phone': emailOrPhone,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = data['token'] as String;
        await _cacheService.saveToken(token);
        final savedToken = await _cacheService.getToken();
        if (token != savedToken) {}
        // حفظ الـ cookie
        final sessionCookie = response.headers['set-cookie']?.split(';').first;
        if (sessionCookie != null) {
          await _cacheService.saveSessionCookie(sessionCookie);
        }

        final testResponse = await http.get(
          Uri.parse('${ApiEndpoints.baseUrl}/my-list-orders'),
          headers: {
            'Authorization': 'Bearer $token',
            'x-api-key': ApiEndpoints.api_key,
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (sessionCookie != null)
              'Cookie': sessionCookie, // نضيف الـ cookie فقط إذا كان موجوداً
          },
        );

        return Right({
          'user': UserModel.fromJson(data['user']),
          'token': token,
          'message': data['message'] ?? 'تم تسجيل الدخول بنجاح',
        });
      } else {
        final message = data['message'] ??
            (data['errors'] != null
                ? data['errors'].values.first.first
                : null) ??
            'فشل تسجيل الدخول';
        return Left(ServerFailure(message: message));
      }
    } on SocketException {
      return Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> register(
    Map<String, dynamic> userData,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

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
        return Left(ServerFailure(message: data['message'] ?? 'حدث خطأ في التسجيل'));
      }
    } on SocketException {
      return Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await _cacheService.getToken();
      final sessionCookie = await _cacheService.getSessionCookie();

      final response = await http.post(
        Uri.parse('${ApiEndpoints.logout}?api_key=${ApiEndpoints.api_key}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
        body: '{}',
      );
      await _cacheService.clearCache();
      return const Right(null);

    } catch (e) {
      await _cacheService.clearCache();
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

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
        final message = data['errors']?['email']?.first ??
            'حدث خطأ في إرسال رابط إعادة تعيين كلمة المرور';
        return Left(ServerFailure(message: message));
      }
    } on SocketException {
      return Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

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
        return Left(ServerFailure(message: message));
      }
    } on SocketException {
      return Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final result = await remoteDataSource.refreshToken();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }
}
