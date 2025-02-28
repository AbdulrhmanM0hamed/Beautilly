import 'dart:convert';
import 'dart:io';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/auth/domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../../../../core/services/cache/cache_service.dart';
import '../models/order_model.dart';
import '../models/order_request_model.dart';
import '../models/order_details_model.dart';
import 'package:path/path.dart' as path;

abstract class OrdersRemoteDataSource {
  Future<OrdersResponseModel> getMyOrders({int page = 1});
  Future<OrdersResponseModel> getAllOrders({int page = 1});
  // Future<List<OrderModel>> getMyReservations();
  Future<Map<String, dynamic>> addOrder(OrderRequestModel order);
  Future<void> deleteOrder(int orderId);
  Future<OrderDetailsModel> getOrderDetails(int orderId);
  Future<void> acceptOffer(int orderId, int offerId);
  Future<void> cancelOffer(int orderId, int offerId);
}

class OrdersRemoteDataSourceImpl
    with TokenRefreshMixin
    implements OrdersRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;
  final AuthRepository authRepository;

  OrdersRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
    required this.authRepository,
  });

  @override
  Future<OrdersResponseModel> getMyOrders({int page = 1}) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();
        final queryParameters = {'page': page.toString()};
        
        final uri = Uri.parse(ApiEndpoints.myOrders).replace(queryParameters: queryParameters);
        
        final response = await client.get(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'x-api-key': ApiEndpoints.api_key,
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
        );

        if (response.statusCode == 200) {
          final decodedData = json.decode(response.body);
          return OrdersResponseModel.fromJson(decodedData);
        } else {
          throw ServerException(message: 'فشل في تحميل الطلبات');
        }
      },
    );
  }

  @override
  Future<OrdersResponseModel> getAllOrders({int page = 1}) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();
        final queryParameters = {'page': page.toString()};
        
        final uri = Uri.parse(ApiEndpoints.allOrders).replace(queryParameters: queryParameters);
        
        final response = await client.get(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'x-api-key': ApiEndpoints.api_key,
            'Content-Type': 'application/json',
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
        );

        if (response.statusCode == 200) {
          final decodedData = json.decode(response.body);
          return OrdersResponseModel.fromJson(decodedData);
        } else {
          throw ServerException(message: 'فشل في تحميل الطلبات');
        }
      },
    );
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

      // إضافة مصفوفة الأقمشة
      for (var i = 0; i < order.fabrics.length; i++) {
        request.fields['fabrics[$i][type]'] = order.fabrics[i].type;
        request.fields['fabrics[$i][color]'] = order.fabrics[i].color;
      }

      // إضافة الصورة المضغوطة
      final imageFile = File(order.imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final imageLength = await imageFile.length();
      
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: path.basename(order.imagePath),
          contentType: MediaType('image', '*'),
        ),
      );

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          return jsonResponse['data'];
        }
        throw ServerException(
            message: jsonResponse['message'] ?? 'فشل في إضافة الطلب');
      }

      throw ServerException(
          message: 'فشل في إضافة الطلب: ${response.statusCode}');
    } catch (e) {
      throw ServerException(message: 'حدث خطأ أثناء إضافة الطلب');
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
        throw ServerException(message: 'فشل في حذف الطلب');
      }

      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] != true) {
        throw ServerException(
            message: jsonResponse['message'] ?? 'فشل في حذف الطلب');
      }
    } catch (e) {
      throw ServerException(message: 'حدث خطأ أثناء حذف الطلب');
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
              message: jsonResponse['message'] ?? 'فشل في تحميل تفاصيل الطلب');
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            'انتهت صلاحية الجلسة  ، يرجى إعادة تسجيل الدخول');
      } else {
        final error = json.decode(response.body);
        throw ServerException(
            message: error['message'] ?? 'فشل في تحميل تفاصيل الطلب');
      }
    } catch (e) {
      throw ServerException(message: 'حدث خطأ غير متوقع: $e');
    }
  }

  @override
  Future<void> acceptOffer(int orderId, int offerId) async {
    try {
      final token = await cacheService.getToken();
      final sessionCookie = await cacheService.getSessionCookie();

      if (token == null) {
        throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
      }

      final response = await client.post(
        Uri.parse(ApiEndpoints.acceptOffer(orderId, offerId)),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] != true) {
          throw ServerException(
              message: jsonResponse['message'] ?? 'فشل في قبول العرض');
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
      } else {
        final error = json.decode(response.body);
        throw ServerException(message: error['message'] ?? 'فشل في قبول العرض');
      }
    } catch (e) {
      throw ServerException(message: 'حدث خطأ أثناء قبول العرض');
    }
  }

  @override
  Future<void> cancelOffer(int orderId, int offerId) async {
    try {
      final token = await cacheService.getToken();
      final sessionCookie = await cacheService.getSessionCookie();

      if (token == null) {
        throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
      }

      final response = await client.post(
        Uri.parse(ApiEndpoints.cancelOffer(orderId, offerId)),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'x-api-key': ApiEndpoints.api_key,
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] != true) {
          throw ServerException(
              message: jsonResponse['message'] ?? 'فشل في قبول العرض');
        }
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
            'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
      } else {
        final error = json.decode(response.body);
        throw ServerException(message: error['message'] ?? 'فشل في قبول العرض');
      }
    } catch (e) {
      throw ServerException(message: 'حدث خطأ أثناء قبول العرض');
    }
  }
}
