import 'package:beautilly/features/orders/domain/entities/order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_orders.dart';
import '../../domain/usecases/get_all_orders.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetMyOrders getMyOrders;
  //final GetMyReservations getMyReservations;
  final GetAllOrders getAllOrders;
  
  List<OrderEntity>? _myOrders;    // تغيير النوع
  List<OrderEntity>? _allOrders;   // تغيير النوع

  OrdersCubit({
    required this.getMyOrders,
 //   required this.getMyReservations,
    required this.getAllOrders,
  }) : super(OrdersInitial());

  Future<void> loadMyOrders() async {
    if (_myOrders != null) {
      emit(MyOrdersSuccess(_myOrders!));
    } else {
      emit(OrdersLoading());
    }

    final result = await getMyOrders();
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) {
        _myOrders = orders;
        emit(MyOrdersSuccess(orders));
      },
    );
  }

  Future<void> loadAllOrders() async {
    if (_allOrders != null) {
      emit(AllOrdersSuccess(_allOrders!));
    } else {
      emit(OrdersLoading());
    }

    final result = await getAllOrders();
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) {
        _allOrders = orders;
        emit(AllOrdersSuccess(orders));
      },
    );
  }

  // تحديث الكاش عند حذف طلب
  void removeOrderFromCache(int orderId) {
    if (_myOrders != null) {
      _myOrders!.removeWhere((order) => order.id == orderId);
    }
    if (_allOrders != null) {
      _allOrders!.removeWhere((order) => order.id == orderId);
    }
  }

  // مسح الكاش عند تسجيل الخروج أو عند الحاجة
  void clearCache() {
    _myOrders = null;
    _allOrders = null;
  }
} 