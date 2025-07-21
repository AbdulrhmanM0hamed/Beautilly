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
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
       // print("the token is $token");
        final sessionCookie = await cacheService.getSessionCookie();
     //   print("the session is $sessionCookie");
        final response = await client.get(
          Uri.parse(ApiEndpoints.myReservations),
          headers: {
            'Authorization': 'Bearer $token',
            'x-api-key': ApiEndpoints.apiKey,
            'Accept': 'application/json',
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
        );

        if (response.statusCode == 200) {
          return _parseResponse(response);
        } else {
          throw ServerException(message: 'فشل في تحميل الحجوزات');
        }
      },
    );
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
          message: jsonResponse['message'] ?? 'حدث خطأ في تحميل الحجوزات');
    }
  }
}
