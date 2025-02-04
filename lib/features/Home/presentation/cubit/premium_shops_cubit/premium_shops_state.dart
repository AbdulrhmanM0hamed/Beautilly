import '../../../domain/entities/premium_shop.dart';

abstract class PremiumShopsState {}

class PremiumShopsInitial extends PremiumShopsState {}

class PremiumShopsLoading extends PremiumShopsState {}

class PremiumShopsLoaded extends PremiumShopsState {
  final List<PremiumShop> shops;

  PremiumShopsLoaded(this.shops);
}

class PremiumShopsError extends PremiumShopsState {
  final String message;

  PremiumShopsError(this.message);
} 