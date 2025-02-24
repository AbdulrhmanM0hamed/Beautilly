import '../../domain/entities/order.dart';
import 'package:equatable/equatable.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

class MyOrdersSuccess extends OrdersState {
  final List<OrderEntity> orders;
  final OrderPagination pagination;

  const MyOrdersSuccess(this.orders, this.pagination);

  @override
  List<Object?> get props => [orders, pagination];
}

class AllOrdersSuccess extends OrdersState {
  final List<OrderEntity> orders;
  final OrderPagination pagination;

  const AllOrdersSuccess(this.orders, this.pagination);

  @override
  List<Object?> get props => [orders, pagination];
} 