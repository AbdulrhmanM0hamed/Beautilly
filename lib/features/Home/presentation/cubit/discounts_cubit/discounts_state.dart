import '../../../domain/entities/discount.dart';

abstract class DiscountsState {}

class DiscountsInitial extends DiscountsState {}

class DiscountsLoading extends DiscountsState {}

class DiscountsLoaded extends DiscountsState {
  final List<Discount> discounts;

  DiscountsLoaded(this.discounts);
}

class DiscountsError extends DiscountsState {
  final String message;

  DiscountsError(this.message);
} 