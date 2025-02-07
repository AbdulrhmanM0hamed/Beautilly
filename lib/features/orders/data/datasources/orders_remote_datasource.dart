import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../models/order_model.dart';
import '../models/order_request_model.dart';
import '../models/order_details_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getMyOrders();
  // Future<List<OrderModel>> getMyReservations();
  Future<List<OrderModel>> getAllOrders();
  Future<Map<String, dynamic>> addOrder(OrderRequestModel order);
  Future<void> deleteOrder(int orderId);
  Future<OrderDetailsModel> getOrderDetails(int orderId);
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
    try {
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
        final List<dynamic> orders = jsonResponse['data'] as List;
        return orders.map((order) => OrderModel.fromJson(order)).toList();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
      } else {
        final error = json.decode(response.body);
        throw ServerException(error['message'] ?? 'فشل في تحميل الطلبات');
      }
    } catch (e, stackTrace) {
      throw ServerException('حدث خطأ غير متوقع: $e');
    }
  }

  // @override
  // Future<List<OrderModel>> getMyReservations() async {
  //   // نفس المنطق مع تغيير الـ endpoint
  //   final token = await cacheService.getToken();
  //   final sessionCookie = await cacheService.getSessionCookie();

  //   if (token == null) {
  //     throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
  //   }

  //   final response = await client.get(
  //     Uri.parse(ApiEndpoints.myReservations),
  //     headers: {
  //       HttpHeaders.authorizationHeader: 'Bearer $token',
  //       'x-api-key': ApiEndpoints.api_key,
  //       HttpHeaders.acceptHeader: 'application/json',
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //       if (sessionCookie != null) 'Cookie': sessionCookie,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     return (jsonResponse['data'] as List)
  //         .map((order) => OrderModel.fromJson(order))
  //         .toList();
  //   } else if (response.statusCode == 401) {
  //     throw UnauthorizedException(
  //         'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
  //   } else {
  //     throw ServerException('فشل في تحميل الحجوزات');
  //   }
  // }

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

  @override
  Future<Map<String, dynamic>> addOrder(OrderRequestModel order) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndpoints.addMyOrder),
      );

      // إضافة الهيدرز
      final token = await cacheService.getToken();
      final sessionCookie = await cacheService.getSessionCookie();
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'x-api-key': ApiEndpoints.api_key,
        if (sessionCookie != null) 'Cookie': sessionCookie,
      });

      // إضافة البيانات الأساسية
      request.fields.addAll({
        'height': order.height.toString(),
        'weight': order.weight.toString(),
        'size': order.size,
        'description': order.description,
        'execution_time': order.executionTime.toString(),
        'api_key': ApiEndpoints.api_key,
      });

      // إضافة مصفوفة الأقمشة بالطريقة الصحيحة
      for (var i = 0; i < order.fabrics.length; i++) {
        request.fields['fabrics[$i][type]'] = order.fabrics[i].type;
        request.fields['fabrics[$i][color]'] = order.fabrics[i].color;
      }

      // إضافة الصورة
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          order.imagePath,
          contentType: MediaType('image', '*'),
        ),
      );

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          return jsonResponse['data'];
        }
        throw ServerException(jsonResponse['message'] ?? 'فشل في إضافة الطلب');
      }

      throw ServerException('فشل في إضافة الطلب: ${response.statusCode}');
    } catch (e) {
      throw ServerException('حدث خطأ أثناء إضافة الطلب');
    }
  }

  @override
  Future<void> deleteOrder(int orderId) async {
    try {
      final token = await cacheService.getToken();
      final sessionCookie = await cacheService.getSessionCookie();

      final response = await http.delete(
        Uri.parse(ApiEndpoints.deleteOrder(orderId)),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'x-api-key': ApiEndpoints.api_key,
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException('فشل في حذف الطلب');
      }

      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] != true) {
        throw ServerException(jsonResponse['message'] ?? 'فشل في حذف الطلب');
      }
    } catch (e) {
      throw ServerException('حدث خطأ أثناء حذف الطلب');
    }
  }

  @override
  Future<OrderDetailsModel> getOrderDetails(int orderId) async {
    try {
      final token = await cacheService.getToken();
      final sessionCookie = await cacheService.getSessionCookie();

      if (token == null) {
        throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
      }

      final response = await client.get(
        Uri.parse(ApiEndpoints.orderDetails(orderId)),
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

        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final orderData = jsonResponse['data']['order'];
          return OrderDetailsModel.fromJson(orderData);
        } else {
          throw ServerException(
              jsonResponse['message'] ?? 'فشل في تحميل تفاصيل الطلب');
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
      } else {
        final error = json.decode(response.body);
        throw ServerException(error['message'] ?? 'فشل في تحميل تفاصيل الطلب');
      }
    } catch (e) {
      throw ServerException('حدث خطأ غير متوقع: $e');
    }
  }
}
