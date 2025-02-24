import 'package:beautilly/features/orders/domain/entities/order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_orders.dart';
import '../../domain/usecases/get_all_orders.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetMyOrders getMyOrders;
  final GetAllOrders getAllOrders;
  
  // تخزين بيانات الصفحات
  OrdersResponse? _myOrdersResponse;
  OrdersResponse? _allOrdersResponse;
  
  // حالة التحميل للصفحات التالية
  bool _isLoadingMoreMyOrders = false;
  bool _isLoadingMoreAllOrders = false;

  OrdersCubit({
    required this.getMyOrders,
    required this.getAllOrders,
  }) : super(OrdersInitial());

  Future<void> loadMyOrders({int page = 1}) async {
    if (page == 1) {
      if (_myOrdersResponse != null) {
        emit(MyOrdersSuccess(_myOrdersResponse!.orders, _myOrdersResponse!.pagination));
      } else {
        emit(OrdersLoading());
      }
    } else {
      _isLoadingMoreMyOrders = true;
    }

    final result = await getMyOrders(page: page);
    result.fold(
      (failure) {
        _isLoadingMoreMyOrders = false;
        emit(OrdersError(failure.message));
      },
      (ordersResponse) {
        _isLoadingMoreMyOrders = false;
        if (page == 1) {
          _myOrdersResponse = ordersResponse;
        } else {
          _myOrdersResponse = OrdersResponse(
            orders: [..._myOrdersResponse!.orders, ...ordersResponse.orders],
            pagination: ordersResponse.pagination,
          );
        }
        emit(MyOrdersSuccess(_myOrdersResponse!.orders, _myOrdersResponse!.pagination));
      },
    );
  }

  Future<void> loadAllOrders({int page = 1}) async {
    if (page == 1) {
      if (_allOrdersResponse != null) {
        emit(AllOrdersSuccess(_allOrdersResponse!.orders, _allOrdersResponse!.pagination));
      } else {
        emit(OrdersLoading());
      }
    } else {
      _isLoadingMoreAllOrders = true;
    }

    final result = await getAllOrders(page: page);
    result.fold(
      (failure) {
        _isLoadingMoreAllOrders = false;
        emit(OrdersError(failure.message));
      },
      (ordersResponse) {
        _isLoadingMoreAllOrders = false;
        if (page == 1) {
          _allOrdersResponse = ordersResponse;
        } else {
          _allOrdersResponse = OrdersResponse(
            orders: [..._allOrdersResponse!.orders, ...ordersResponse.orders],
            pagination: ordersResponse.pagination,
          );
        }
        emit(AllOrdersSuccess(_allOrdersResponse!.orders, _allOrdersResponse!.pagination));
      },
    );
  }

  bool get canLoadMoreMyOrders {
    return _myOrdersResponse != null &&
        _myOrdersResponse!.pagination.currentPage < _myOrdersResponse!.pagination.lastPage &&
        !_isLoadingMoreMyOrders;
  }

  bool get canLoadMoreAllOrders {
    return _allOrdersResponse != null &&
        _allOrdersResponse!.pagination.currentPage < _allOrdersResponse!.pagination.lastPage &&
        !_isLoadingMoreAllOrders;
  }

  void removeOrderFromCache(int orderId) {
    if (_myOrdersResponse != null) {
      final updatedOrders = _myOrdersResponse!.orders.where((order) => order.id != orderId).toList();
      _myOrdersResponse = OrdersResponse(
        orders: updatedOrders,
        pagination: _myOrdersResponse!.pagination,
      );
    }
    if (_allOrdersResponse != null) {
      final updatedOrders = _allOrdersResponse!.orders.where((order) => order.id != orderId).toList();
      _allOrdersResponse = OrdersResponse(
        orders: updatedOrders,
        pagination: _allOrdersResponse!.pagination,
      );
    }
  }

  void clearCache() {
    _myOrdersResponse = null;
    _allOrdersResponse = null;
    _isLoadingMoreMyOrders = false;
    _isLoadingMoreAllOrders = false;
  }
} 