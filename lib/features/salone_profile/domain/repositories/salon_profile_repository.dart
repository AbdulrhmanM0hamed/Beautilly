import 'package:dartz/dartz.dart';
import 'package:beautilly/core/error/failures.dart';
import '../entities/salon_profile.dart';

abstract class SalonProfileRepository {
  Future<Either<Failure, SalonProfile>> getSalonProfile(int salonId);
} 