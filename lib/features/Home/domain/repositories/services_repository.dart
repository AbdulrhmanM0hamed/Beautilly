import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/service.dart';

abstract class ServicesRepository {
  Future<Either<Failure, List<ServiceEntity>>> getServices();
  Future<Either<Failure, List<ServiceEntity>>> searchServices(String query);
} 