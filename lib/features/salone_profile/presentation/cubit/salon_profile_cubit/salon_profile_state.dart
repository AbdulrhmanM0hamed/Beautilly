import 'package:equatable/equatable.dart';
import '../../../domain/entities/salon_profile.dart';

abstract class SalonProfileState extends Equatable {
  const SalonProfileState();

  @override
  List<Object?> get props => [];
}

class SalonProfileInitial extends SalonProfileState {}

class SalonProfileLoading extends SalonProfileState {}

class SalonProfileLoaded extends SalonProfileState {
  final SalonProfile profile;
  final bool shouldRefresh;

  const SalonProfileLoaded(this.profile, {this.shouldRefresh = false});

  @override
  List<Object?> get props => [profile, shouldRefresh];
}

class SalonProfileError extends SalonProfileState {
  final String message;

  const SalonProfileError(this.message);

  @override
  List<Object?> get props => [message];
} 