import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reservation.dart';
import '../repositories/reservations_repository.dart';

class GetMyReservations {
  final ReservationsRepository repository;

  GetMyReservations(this.repository);

  Future<Either<Failure, List<ReservationEntity>>> call() async {
    return await repository.getMyReservations();
  }
} 