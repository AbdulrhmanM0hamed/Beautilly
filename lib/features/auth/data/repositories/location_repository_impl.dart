import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../models/city_model.dart';
import '../models/state_model.dart';
import '../../domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final http.Client _client = http.Client();

  @override
  Future<Either<Failure, List<StateModel>>> getStates() async {
    try {
      final response = await _client.post(
        Uri.parse(ApiEndpoints.register),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'x-api-key': ApiEndpoints.api_key,
        },
        body: jsonEncode({
          'load_states': true,
          'country': 'المملكة العربية السعودية',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final Map<String, dynamic> statesData = jsonResponse['states'];

        final List<StateModel> states = statesData.entries
            .map((entry) => StateModel(
                  id: int.parse(entry.key),
                  name: entry.value.toString(),
                ))
            .toList();

        return Right(states);
      } else {
        return const Left(ServerFailure('فشل في تحميل المناطق'));
      }
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, List<CityModel>>> getCities(int stateId) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiEndpoints.register),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'x-api-key': ApiEndpoints.api_key,
        },
        body: jsonEncode({
          'load_cities': true,
          'state_id': stateId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final Map<String, dynamic> citiesData = jsonResponse['cities'];

        final List<CityModel> cities = citiesData.entries
            .map((entry) => CityModel(
                  id: int.parse(entry.key),
                  name: entry.value.toString(),
                  stateId: stateId,
                ))
            .toList();

        return Right(cities);
      } else {
        return const Left(ServerFailure('فشل في تحميل المدن'));
      }
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, List<CityModel>>> getAllCities() async {
    try {
      final response = await _client.post(
        Uri.parse(ApiEndpoints.register),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'x-api-key': ApiEndpoints.api_key,
        },
        body: jsonEncode({
          'load_cities': true,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final Map<String, dynamic> citiesData = jsonResponse['cities'];

        final List<CityModel> cities = citiesData.entries
            .map((entry) => CityModel(
                  id: int.parse(entry.key),
                  name: entry.value.toString(),
                  stateId: 0, // لا نعرف state_id في هذه الحالة
                ))
            .toList();

        return Right(cities);
      } else {
        return const Left(ServerFailure('فشل في تحميل المدن'));
      }
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }
}
