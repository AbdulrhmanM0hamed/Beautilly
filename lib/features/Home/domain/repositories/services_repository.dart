import 'package:beautilly/features/Home/domain/entities/service_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/service_model.dart';

abstract class ServicesRepository {
  Future<Either<Failure, ServicesResponse>> getServices({int page = 1});
  Future<Either<Failure, List<ServiceEntity>>> searchServices(String query);
} 