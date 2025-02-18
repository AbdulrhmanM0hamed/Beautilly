import 'dart:convert';
import 'package:beautilly/core/utils/constant/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../services/service_locator.dart';
import '../services/cache/cache_service.dart';

class HttpClient {
  final _baseUrl = 'YOUR_BASE_URL';
  final _cacheService = sl<CacheService>();
  
  Future<http.Response> _handleRequest(Future<http.Response> Function() request) async {
    try {
      final response = await request();
      
      if (response.statusCode == 401) {
        // Token expired - try to refresh
        final newToken = await _refreshToken();
        
        if (newToken != null) {
          // Update token in cache
          await _cacheService.saveToken(newToken);
          
          // Retry original request with new token
          final headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $newToken',
          };
          
          // Recreate the original request with new token
          final newResponse = await request();
          return newResponse;
        } else {
          // Refresh token failed
          throw Exception('Session expired');
        }
      }
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await _cacheService.getRefreshToken();
      final response = await http.post(
        Uri.parse(ApiEndpoints.refreshToken),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['access_token'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // استخدام الـ wrapper مع كل request
  Future<http.Response> get(String path, {Map<String, String>? headers}) async {
    return _handleRequest(() async {
      final token = await _cacheService.getToken();
      return http.get(
        Uri.parse('$_baseUrl/$path'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          ...?headers,
        },
      );
    });
  }

  Future<http.Response> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _handleRequest(() async {
      final token = await _cacheService.getToken();
      return http.post(
        Uri.parse('$_baseUrl/$path'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          ...?headers,
        },
        body: json.encode(body),
      );
    });
  }

  // يمكن إضافة باقي الـ methods (put, delete, etc.)
} 