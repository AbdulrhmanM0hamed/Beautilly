import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/service.dart';
import '../repositories/services_repository.dart';

class GetServices {
  final ServicesRepository repository;

  GetServices(this.repository);

  Future<Either<Failure, List<ServiceEntity>>> call() async {
    return await repository.getServices();
  }
} 