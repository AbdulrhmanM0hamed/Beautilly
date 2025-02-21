import 'dart:convert';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/reservation_model.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';

abstract class ReservationsRemoteDataSource {
  Future<List<ReservationModel>> getMyReservations();
}

class ReservationsRemoteDataSourceImpl with TokenRefreshMixin implements ReservationsRemoteDataSource {
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
      if (token == null || token.isEmpty) {
        throw ServerException(message: 'الرجاء إعادة تسجيل الدخول');
      }

      final sessionCookie = await cacheService.getSessionCookie();
      final response = await client.get(
        Uri.parse('${ApiEndpoints.baseUrl}/my-reservations'),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => ReservationModel.fromJson(json)).toList();
      } else {
        final error = json.decode(response.body);
        throw ServerException(message: error['message'] ?? 'حدث خطأ في الخادم');
      }
    } catch (e) {
      rethrow;
    }
  }
}
