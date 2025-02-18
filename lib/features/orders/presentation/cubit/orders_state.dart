import '../../domain/entities/order.dart';

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersError extends OrdersState {
  final String message;
  OrdersError(this.message);
}

class MyOrdersSuccess extends OrdersState {
  final List<OrderEntity> orders;
  MyOrdersSuccess(this.orders);
}

class AllOrdersSuccess extends OrdersState {
  final List<OrderEntity> orders;
  AllOrdersSuccess(this.orders);
} 