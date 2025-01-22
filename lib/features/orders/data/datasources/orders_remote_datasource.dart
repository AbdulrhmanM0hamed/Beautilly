import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getMyOrders();
  Future<List<OrderModel>> getMyReservations();
  Future<List<OrderModel>> getAllOrders();
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;

  OrdersRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
  });

  @override
  Future<List<OrderModel>> getMyOrders() async {
    final token = await cacheService.getToken();
    final sessionCookie = await cacheService.getSessionCookie();
    
    if (token == null) {
      throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
    }

    final response = await client.get(
      Uri.parse(ApiEndpoints.myOrders),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'x-api-key': ApiEndpoints.api_key,
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        if (sessionCookie != null) 'Cookie': sessionCookie,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return (jsonResponse['data'] as List)
          .map((order) => OrderModel.fromJson(order))
          .toList();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException('انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
    } else {
      throw ServerException('فشل في تحميل الطلبات');
    }
  }

  @override
  Future<List<OrderModel>> getMyReservations() async {
    // نفس المنطق مع تغيير الـ endpoint
    final token = await cacheService.getToken();
    final sessionCookie = await cacheService.getSessionCookie();
    
    if (token == null) {
      throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
    }

    final response = await client.get(
      Uri.parse(ApiEndpoints.myReservations),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'x-api-key': ApiEndpoints.api_key,
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        if (sessionCookie != null) 'Cookie': sessionCookie,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return (jsonResponse['data'] as List)
          .map((order) => OrderModel.fromJson(order))
          .toList();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException('انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
    } else {
      throw ServerException('فشل في تحميل الحجوزات');
    }
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final token = await cacheService.getToken();
      final sessionCookie = await cacheService.getSessionCookie();
      
      if (token == null) {
        throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
      }

      final response = await client.get(
        Uri.parse('${ApiEndpoints.baseUrl}/list-orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => OrderModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('يرجى تسجيل الدخول مرة أخرى');
      } else {
        final error = json.decode(response.body);
        throw ServerException(error['message'] ?? 'حدث خطأ في الخادم');
      }
    } catch (e) {
      rethrow;
    }
  }
} 