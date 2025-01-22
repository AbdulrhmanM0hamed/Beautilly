import 'package:equatable/equatable.dart';
import '../../domain/entities/reservation.dart';

abstract class ReservationsState extends Equatable {
  const ReservationsState();

  @override
  List<Object?> get props => [];
}

class ReservationsInitial extends ReservationsState {}

class ReservationsLoading extends ReservationsState {}

class ReservationsSuccess extends ReservationsState {
  final List<ReservationEntity> reservations;

  const ReservationsSuccess(this.reservations);

  @override
  List<Object?> get props => [reservations];
}

class ReservationsError extends ReservationsState {
  final String message;

  const ReservationsError(this.message);

  @override
  List<Object?> get props => [message];
} 