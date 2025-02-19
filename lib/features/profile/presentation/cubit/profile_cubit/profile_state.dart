import 'package:beautilly/features/profile/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileValidationError extends ProfileState {
  final String message;
  final dynamic validationErrors;

  const ProfileValidationError({
    required this.message,
    this.validationErrors,
  });

  @override
  List<Object?> get props => [message, validationErrors];
}

class ProfileSuccess extends ProfileState {
  final String message;

  const ProfileSuccess(this.message);

  @override
  List<Object?> get props => [message];
}