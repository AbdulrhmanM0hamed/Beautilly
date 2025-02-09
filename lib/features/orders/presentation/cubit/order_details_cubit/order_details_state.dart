import 'package:beautilly/features/orders/domain/entities/order_details.dart';

abstract class OrderDetailsState {}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsSuccess extends OrderDetailsState {
  final OrderDetails orderDetails;

  OrderDetailsSuccess(this.orderDetails);
}

class OrderDetailsError extends OrderDetailsState {
  final String message;

  OrderDetailsError(this.message);
} 