import 'package:equatable/equatable.dart';
import '../../../domain/entities/service_entity.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {
  final bool isLoadingMore;
  
  const ServicesLoading({this.isLoadingMore = false});
  
  @override
  List<Object?> get props => [isLoadingMore];
}

class ServicesLoaded extends ServicesState {
  final List<ServiceEntity> services;
  final bool isLastPage;

  const ServicesLoaded({
    required this.services,
    required this.isLastPage,
  });

  @override
  List<Object?> get props => [services, isLastPage];
}

class ServicesError extends ServicesState {
  final String message;

  const ServicesError(this.message);

  @override
  List<Object?> get props => [message];
} 