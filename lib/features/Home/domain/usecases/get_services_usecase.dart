import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/service_model.dart';
import '../repositories/services_repository.dart';

class GetServices {
  final ServicesRepository repository;

  GetServices(this.repository);

  Future<Either<Failure, ServicesResponse>> call({int page = 1}) async {
    return await repository.getServices(page: page);
  }
} 