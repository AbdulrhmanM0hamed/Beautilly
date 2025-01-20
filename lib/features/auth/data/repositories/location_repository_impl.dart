import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../../../../core/utils/constant/api_endpoints.dart';
import '../../domain/repositories/location_repository.dart';
import '../models/state_model.dart';
import '../models/city_model.dart';


class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<Either<Failure, List<StateModel>>> getStates() async {
    try {
      final uri = Uri.parse(ApiEndpoints.register);

      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'load_states': 1,
        }),
      );


      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> states = responseData['states'];
        
        final List<StateModel> statesList = states.entries
            .map((e) => StateModel(
                  id: int.parse(e.key), 
                  name: e.value.toString(),
                ))
            .toList();
        
        return Right(statesList);
      }
      return const Left(ServerFailure('فشل في تحميل المناطق'));
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ ما'));
    }
  }


  @override
  Future<Either<Failure, List<CityModel>>> getCities(int stateId) async {
    try {
      final uri = Uri.parse(ApiEndpoints.register);

      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'load_cities': 1,
          'state_id': stateId,
        }),
      );


      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> cities = responseData['cities'];
        
        final List<CityModel> citiesList = cities.entries
            .map((e) => CityModel(
                  id: int.parse(e.key), 
                  name: e.value.toString(),
                ))
            .toList();
        
        return Right(citiesList);
      }
      return const Left(ServerFailure('فشل في تحميل المدن'));
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ ما'));
    }
  }
} 