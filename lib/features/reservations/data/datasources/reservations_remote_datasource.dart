import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/reservation_model.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';

abstract class ReservationsRemoteDataSource {
  Future<List<ReservationModel>> getMyReservations();
}

class ReservationsRemoteDataSourceImpl implements ReservationsRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;
  final AuthRepository authRepository;

  ReservationsRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
    required this.authRepository,
  });

  @override
  Future<List<ReservationModel>> getMyReservations() async {
    try {
      final token = await cacheService.getToken();
      final sessionCookie = await cacheService.getSessionCookie();

      if (token == null) {
        throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
      }

      final response = await client.get(
        Uri.parse(ApiEndpoints.myReservations),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 401) {
        final refreshResult = await authRepository.refreshToken();
        return refreshResult.fold(
          (failure) => throw UnauthorizedException('يرجى إعادة تسجيل الدخول'),
          (newToken) async {
            final newResponse = await client.get(
              Uri.parse(ApiEndpoints.myReservations),
              headers: {
                'Authorization': 'Bearer $newToken',
                'x-api-key': ApiEndpoints.api_key,
                'Accept': 'application/json',
                if (sessionCookie != null) 'Cookie': sessionCookie,
              },
            );

            if (newResponse.statusCode == 200) {
              return _parseResponse(newResponse);
            } else {
              throw ServerException('فشل في تحميل الحجوزات');
            }
          },
        );
      }

      if (response.statusCode == 200) {
        return _parseResponse(response);
      } else {
        throw ServerException('فشل في تحميل الحجوزات');
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      if (e is ServerException) rethrow;
      throw ServerException('حدث خطأ غير متوقع: $e');
    }
  }

  List<ReservationModel> _parseResponse(http.Response response) {
    final jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == true) {
      final reservationsData = jsonResponse['data']['reservations'] as List;
      return reservationsData
          .map((reservation) => ReservationModel.fromJson(reservation))
          .toList();
    } else {
      throw ServerException(
          jsonResponse['message'] ?? 'حدث خطأ في تحميل الحجوزات');
    }
  }
}
