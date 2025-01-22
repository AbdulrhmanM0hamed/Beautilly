import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reservation.dart';

abstract class ReservationsRepository {
  Future<Either<Failure, List<ReservationEntity>>> getMyReservations();
} 