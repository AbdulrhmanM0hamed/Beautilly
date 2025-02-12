import 'package:beautilly/features/Home/domain/entities/service.dart';

abstract class ServiceShopsState {}

class ServiceShopsInitial extends ServiceShopsState {}

class ServiceShopsLoading extends ServiceShopsState {}

class ServiceShopsLoaded extends ServiceShopsState {
  final List<ShopEntity> shops;

  ServiceShopsLoaded({required this.shops});
}

class ServiceShopsError extends ServiceShopsState {
  final String message;

  ServiceShopsError({required this.message});
} 