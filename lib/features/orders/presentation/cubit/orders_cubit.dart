import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_orders.dart';
import '../../domain/usecases/get_all_orders.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetMyOrders getMyOrders;
  //final GetMyReservations getMyReservations;
  final GetAllOrders getAllOrders;

  OrdersCubit({
    required this.getMyOrders,
 //   required this.getMyReservations,
    required this.getAllOrders,
  }) : super(OrdersInitial());

  Future<void> loadMyOrders() async {
    if (isClosed) return;
    emit(OrdersLoading());
    
    final result = await getMyOrders();
    
    if (isClosed) return;
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(OrdersSuccess(orders)),
    );
  }

  Future<void> loadAllOrders() async {
    if (isClosed) return;
    emit(OrdersLoading());
    
    final result = await getAllOrders();
    
    if (isClosed) return;
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(OrdersSuccess(orders)),
    );
  }
} 