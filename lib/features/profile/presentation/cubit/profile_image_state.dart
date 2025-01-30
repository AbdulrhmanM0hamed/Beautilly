import 'package:equatable/equatable.dart';

abstract class ProfileImageState extends Equatable {
  const ProfileImageState();

  @override
  List<Object?> get props => [];
}

class ProfileImageInitial extends ProfileImageState {}

class ProfileImageLoading extends ProfileImageState {}

class ProfileImageSuccess extends ProfileImageState {
  final String imageUrl;
  final String message;

  const ProfileImageSuccess({
    required this.imageUrl,
    required this.message,
  });

  @override
  List<Object?> get props => [imageUrl, message];
}

class ProfileImageError extends ProfileImageState {
  final String message;

  const ProfileImageError(this.message);

  @override
  List<Object?> get props => [message];
} 