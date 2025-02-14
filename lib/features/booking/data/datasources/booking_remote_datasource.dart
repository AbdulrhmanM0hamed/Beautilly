import 'dart:convert';
import 'package:beautilly/features/booking/domain/entities/available_time.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/available_date_model.dart';

abstract class BookingRemoteDataSource {
  Future<void> bookService({
    required int shopId,
    required int serviceId,
    required int dayId,
    required int timeId,
  });

  Future<void> bookDiscount({
    required int shopId,
    required int discountId,
    required int dayId,
    required int timeId,
  });

  Future<List<AvailableDate>> getAvailableDates(int shopId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;

  BookingRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
  });

  @override
  Future<void> bookService({
    required int shopId,
    required int serviceId,
    required int dayId,
    required int timeId,
  }) async {
    final token = await cacheService.getToken();
    final sessionCookie = await cacheService.getSessionCookie();

    if (token == null) {
      throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
    }

    try {
      final response = await client.post(
        Uri.parse(ApiEndpoints.bookService(shopId)),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
        body: json.encode({
          'service_id': serviceId,
          'day_id': dayId,
          'time_id': timeId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          return;
        } else {
          throw ServerException(
              jsonResponse['message'] ?? 'حدث خطأ في عملية الحجز');
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
      } else {
        throw ServerException('فشل في عملية الحجز');
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      if (e is ServerException) rethrow;
      throw ServerException('حدث خطأ غير متوقع');
    }
  }

  @override
  Future<void> bookDiscount({
    required int shopId,
    required int discountId,
    required int dayId,
    required int timeId,
  }) async {
    final token = await cacheService.getToken();
    final sessionCookie = await cacheService.getSessionCookie();

    if (token == null) {
      throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
    }

    try {
      final response = await client.post(
        Uri.parse(ApiEndpoints.bookDiscount(shopId)),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
        body: json.encode({
          'discount_id': discountId,
          'day_id': dayId,
          'time_id': timeId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          return;
        } else {
          throw ServerException(
              jsonResponse['message'] ?? 'حدث خطأ في عملية حجز العرض');
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
      } else {
        throw ServerException('فشل في عملية حجز العرض');
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      if (e is ServerException) rethrow;
      throw ServerException('حدث خطأ غير متوقع');
    }
  }

  @override
  Future<List<AvailableDate>> getAvailableDates(int shopId) async {
    final token = await cacheService.getToken();
    final sessionCookie = await cacheService.getSessionCookie();

    if (token == null) {
      throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
    }

    try {
      final response = await client.get(
        Uri.parse(ApiEndpoints.shopFullDetails(shopId)),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data']['available_dates'] as Map<String, dynamic>;
          final dates = (data['items'] as List)
              .map((date) => AvailableDateModel.fromJson(date))
              .toList();
          return dates;
        } else {
          throw ServerException(
              jsonResponse['message'] ?? 'حدث خطأ في تحميل المواعيد المتاحة');
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
      } else {
        throw ServerException('فشل في تحميل المواعيد المتاحة');
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      if (e is ServerException) rethrow;
      throw ServerException('حدث خطأ غير متوقع');
    }
  }
} 