import 'package:dartz/dartz.dart';
import 'package:beautilly/core/error/failures.dart';
import '../entities/salon_profile.dart';
import '../repositories/salon_profile_repository.dart';

class GetSalonProfileUseCase {
  final SalonProfileRepository repository;

  GetSalonProfileUseCase(this.repository);

  @override
  Future<Either<Failure, SalonProfile>> call(int params) async {
    return await repository.getSalonProfile(params);
  }
}
