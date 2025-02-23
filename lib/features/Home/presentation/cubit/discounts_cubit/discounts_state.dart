import '../../../domain/entities/discount.dart';

abstract class DiscountsState {}

class DiscountsInitial extends DiscountsState {}

class DiscountsLoading extends DiscountsState {}

class DiscountsLoaded extends DiscountsState {
  final List<Discount> discounts;
  final bool isLastPage;

  DiscountsLoaded({
    required this.discounts,
    required this.isLastPage,
  });
}

class DiscountsError extends DiscountsState {
  final String message;

  DiscountsError(this.message);
} 