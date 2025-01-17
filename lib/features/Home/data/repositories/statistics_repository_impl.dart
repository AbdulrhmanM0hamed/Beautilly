import 'dart:convert';
import 'package:beautilly/core/services/cache/shared_preferences_service.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/statistics_model.dart';
import '../../domain/repositories/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final SharedPreferencesService _cache;

  StatisticsRepositoryImpl(this._cache);

  @override
  Future<Either<Failure, StatisticsModel>> getStatistics() async {
    try {
      // محاولة جلب البيانات من الكاش أولاً
      final cachedData = _cache.getStatistics();
      if (cachedData != null) {
        return Right(StatisticsModel.fromJson(cachedData));
      }

      // إذا لم يوجد كاش صالح، نجلب من API
      final response = await http.get(
        Uri.parse(ApiEndpoints.statistics),
        headers: {
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // تخزين البيانات الجديدة في الكاش
        await _cache.cacheStatistics(data['data']);
        return Right(StatisticsModel.fromJson(data['data']));
      } else {
        return const Left(ServerFailure('فشل في تحميل الإحصائيات'));
      }
    } catch (e) {
      // في حالة الخطأ، نحاول استخدام الكاش إذا وجد
      final cachedData = _cache.getStatistics();
      if (cachedData != null) {
        return Right(StatisticsModel.fromJson(cachedData));
      }
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }
}
