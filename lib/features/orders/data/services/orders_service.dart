import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';
import '../../../../core/services/cache/cache_service.dart';

class OrdersService {
  static const String baseUrl = 'https://dallik.com/api';
  static const String apiKey = 'uYtG5w92uQfNkl47pT3MxRvA1zqZ8OjY';
  final CacheService _cacheService;

  OrdersService(this._cacheService);

  Future<List<OrderModel>> getMyOrders() async {
    try {
      final token = await _cacheService.getToken();
      final sessionCookie = await _cacheService.getSessionCookie();
      
      if (token == null) {
        throw Exception('يرجى تسجيل الدخول أولاً');
      }

      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'x-api-key': apiKey,
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        if (sessionCookie != null) 'Cookie': sessionCookie,
      };

      // طباعة الـ headers بشكل مفصل
      print('Debug - Headers Details:');
      headers.forEach((key, value) {
        print('  $key: "$value"');  // نضيف علامات الاقتباس لنرى الفراغات
      });

      final response = await http.get(
        Uri.parse('$baseUrl/my-list-orders'),
        headers: headers,
      );

      // طباعة تفاصيل الطلب والاستجابة
      print('\nDebug - Full Request-Response Cycle:');
      print('URL: ${response.request?.url}');
      print('Method: ${response.request?.method}');
      print('Request Headers: ${response.request?.headers}');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}\n');

      if (response.statusCode == 401) {
        final errorData = json.decode(response.body);
        if (errorData['message'] == 'Unauthenticated.') {
       //   await _cacheService.clearCache();
          throw Exception('انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول');
        }
        throw Exception(errorData['message'] ?? 'خطأ في المصادقة');
      }

      if (response.statusCode != 200) {
        throw Exception('فشل في تحميل الطلبات: ${response.statusCode}');
      }

      final jsonResponse = json.decode(response.body);
      return (jsonResponse['data'] as List)
          .map((order) => OrderModel.fromJson(order))
          .toList();
    } catch (e) {
      print('Error in getMyOrders: $e');
      if (e is FormatException) {
        throw Exception('خطأ في تنسيق البيانات');
      }
      rethrow;
    }
  }

  Future<void> getMyReservations() async {
    try {
      final token = await _cacheService.getToken();
      print('Debug - Token from Cache: $token');
      
      if (token == null) {
        throw Exception('يرجى تسجيل الدخول أولاً');
      }

      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer ${token?.trim() ?? ''}',  // إضافة Bearer prefix
        'x-api-key': apiKey,
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
      };

      print('Debug - Full Request:');
      print('URL: $baseUrl/my-reservations');
      print('Headers: $headers');

      final response = await http.get(
        Uri.parse('$baseUrl/my-reservations'),
        headers: headers,
      );

      print('Debug - Response Status: ${response.statusCode}');
      print('Debug - Response Headers: ${response.headers}');
      print('Debug - Response Body: ${response.body}');

    } catch (e) {
      print('Error in getMyReservations: $e');
    }
  }
}
