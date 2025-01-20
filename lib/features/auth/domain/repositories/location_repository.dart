import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/state_model.dart';
import '../../data/models/city_model.dart';

abstract class LocationRepository {
  Future<Either<Failure, List<StateModel>>> getStates();
  Future<Either<Failure, List<CityModel>>> getCities(int stateId);
} 