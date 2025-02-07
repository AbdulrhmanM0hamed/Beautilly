import 'package:beautilly/features/orders/domain/usecases/delete_order_usecase.dart';
import 'package:beautilly/features/orders/presentation/cubit/delete_order_cubit/delete_order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DeleteOrderCubit extends Cubit<DeleteOrderState> {
  final DeleteOrderUseCase deleteOrderUseCase;

  DeleteOrderCubit({required this.deleteOrderUseCase})
      : super(DeleteOrderInitial());

  Future<void> deleteOrder(int orderId) async {
    emit(DeleteOrderLoading());
    final result = await deleteOrderUseCase(orderId);
    result.fold(
      (failure) => emit(DeleteOrderError(failure.message)),
      (_) => emit(DeleteOrderSuccess()),
    );
  }
} 