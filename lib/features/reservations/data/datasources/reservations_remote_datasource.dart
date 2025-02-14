import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/reservation_model.dart';

abstract class ReservationsRemoteDataSource {
  Future<List<ReservationModel>> getMyReservations();
}

class ReservationsRemoteDataSourceImpl implements ReservationsRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;

  ReservationsRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
  });

  @override
  Future<List<ReservationModel>> getMyReservations() async {
    final token = await cacheService.getToken();
    final sessionCookie = await cacheService.getSessionCookie();

    if (token == null) {
      throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
    }

    try {
      final response = await client.get(
        Uri.parse(ApiEndpoints.myReservations),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      // طباعة الـ response للتحقق من المشكلة

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // التحقق من نجاح الطلب
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'] as List;
          print(data);
          // إذا كانت القائمة فارغة
          if (data.isEmpty) {
            return [];
          }

          return data
              .map((reservation) => ReservationModel.fromJson(reservation))
              .toList();
        } else {
          // طباعة رسالة الخطأ من السيرفر إن وجدت
          throw ServerException(
              jsonResponse['message'] ?? 'حدث خطأ في تحميل الحجوزات');
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
      } else {
        // طباعة تفاصيل الخطأ

        throw ServerException('فشل في تحميل الحجوزات');
      }
    } catch (e) {
      // طباعة الخطأ للتحقق
      if (e is UnauthorizedException) rethrow;
      if (e is ServerException) rethrow;
      throw ServerException('حدث خطأ غير متوقع');
    }
  }
}
