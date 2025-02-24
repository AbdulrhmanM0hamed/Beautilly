import '../../../domain/entities/service_entity.dart';

abstract class ServiceShopsState {}

class ServiceShopsInitial extends ServiceShopsState {}

class ServiceShopsLoading extends ServiceShopsState {}

class ServiceShopsLoaded extends ServiceShopsState {
  final List<ServiceShopEntity> shops;
   ServiceShopsLoaded({required this.shops});
}

class ServiceShopsError extends ServiceShopsState {
  final String message;
   ServiceShopsError({required this.message});
} 