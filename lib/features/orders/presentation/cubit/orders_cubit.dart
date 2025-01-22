import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_orders.dart';
import '../../domain/usecases/get_my_reservations.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetMyOrders getMyOrders;
  final GetMyReservations getMyReservations;

  OrdersCubit({
    required this.getMyOrders,
    required this.getMyReservations,
  }) : super(OrdersInitial());

  Future<void> loadMyOrders() async {
    emit(OrdersLoading());
    
    final result = await getMyOrders();
    
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(OrdersSuccess(orders)),
    );
  }

  Future<void> loadMyReservations() async {
    emit(OrdersLoading());
    
    final result = await getMyReservations();
    
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(OrdersSuccess(orders)),
    );
  }
} 