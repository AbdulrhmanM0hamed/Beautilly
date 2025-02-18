import 'dart:convert';
import 'dart:io';
import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/auth/domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:beautilly/core/error/exceptions.dart';
import 'package:beautilly/core/utils/constant/api_endpoints.dart';
import 'package:beautilly/features/salone_profile/data/models/salon_profile_model.dart';
import 'package:beautilly/features/salone_profile/data/models/rating_request_model.dart';

abstract class SalonProfileRemoteDataSource {
  Future<SalonProfileModel> getSalonProfile(int salonId);
  Future<void> addShopRating(int shopId, RatingRequestModel request);
  Future<void> deleteShopRating(int shopId);
  Future<void> addToFavorites(int shopId);
  Future<void> removeFromFavorites(int shopId);
}

class SalonProfileRemoteDataSourceImpl with TokenRefreshMixin implements SalonProfileRemoteDataSource {
  final http.Client client;
  final CacheService cacheService;
  final AuthRepository authRepository;

  SalonProfileRemoteDataSourceImpl({
    required this.client,
    required this.cacheService,
    required this.authRepository,
  });

  @override
  Future<SalonProfileModel> getSalonProfile(int salonId) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();
        final response = await client.get(
          Uri.parse(ApiEndpoints.shopProfile(salonId)),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'x-api-key': ApiEndpoints.api_key,
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
        );

        if (response.statusCode == 200) {
          final decodedJson = json.decode(response.body);
          
          if (decodedJson['success'] == true && decodedJson['data'] != null) {
            try {
              return SalonProfileModel.fromJson(decodedJson['data']);
            } catch (e) {
              throw ServerException('حدث خطأ في معالجة البيانات');
            }
          } else {
            throw ServerException('لا توجد بيانات متاحة');
          }
        } else {
          throw ServerException('فشل في جلب بيانات الصالون');
        }
      },
    );
  }

  @override
  Future<void> addShopRating(int shopId, RatingRequestModel request) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();
        final response = await client.post(
          Uri.parse(ApiEndpoints.addShopRating(shopId)),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'x-api-key': ApiEndpoints.api_key,
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.contentTypeHeader: 'application/json',
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
          body: json.encode(request.toJson()),
        );

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          if (jsonResponse['success'] != true) {
            throw ServerException(
              jsonResponse['message'] ?? 'فشل في إضافة التقييم',
            );
          }
        } else if (response.statusCode == 422) {
          throw ServerException('لديك تقييم سابق لهذا المتجر');
        } else {
          final error = json.decode(response.body);
          throw ServerException(
            error['message'] ?? 'فشل في إضافة التقييم',
          );
        }
      },
    );
  }

  @override
  Future<void> deleteShopRating(int shopId) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();
        final response = await client.delete(
          Uri.parse(ApiEndpoints.deleteShopRating(shopId)),
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
          if (jsonResponse['success'] != true) {
            throw ServerException(
              jsonResponse['message'] ?? 'فشل في حذف التقييم',
            );
          }
        } else if (response.statusCode == 404) {
          throw ServerException('لم يتم العثور على تقييم لحذفه');
        } else {
          final error = json.decode(response.body);
          throw ServerException(
            error['message'] ?? 'فشل في حذف التقييم',
          );
        }
      },
    );
  }

  @override
  Future<void> addToFavorites(int shopId) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();
        final response = await client.post(
          Uri.parse(ApiEndpoints.addToFavorites(shopId)),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'x-api-key': ApiEndpoints.api_key,
            HttpHeaders.acceptHeader: 'application/json',
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
        );

        if (response.statusCode != 200) {
          throw ServerException('فشل في إضافة المتجر للمفضلة');
        }
      },
    );
  }

  @override
  Future<void> removeFromFavorites(int shopId) async {
    return withTokenRefresh(
      authRepository: authRepository,
      cacheService: cacheService,
      request: (token) async {
        final sessionCookie = await cacheService.getSessionCookie();
        final response = await client.delete(
          Uri.parse(ApiEndpoints.removeFromFavorites(shopId)),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'x-api-key': ApiEndpoints.api_key,
            HttpHeaders.acceptHeader: 'application/json',
            if (sessionCookie != null) 'Cookie': sessionCookie,
          },
        );

        if (response.statusCode != 200) {
          throw ServerException('فشل في إزالة المتجر من المفضلة');
        }
      },
    );
  }
}
