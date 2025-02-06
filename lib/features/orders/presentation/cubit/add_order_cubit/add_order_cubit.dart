import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/order_request_model.dart';
import '../../../domain/usecases/add_order_usecase.dart';
import 'add_order_state.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  final AddOrderUseCase addOrderUseCase;

  AddOrderCubit({required this.addOrderUseCase}) : super(AddOrderInitial());

  Future<void> addOrder({
    required double height,
    required double weight,
    required String size,
    required String description,
    required int executionTime,
    required List<FabricModel> fabrics,
    required String imagePath,
  }) async {
    emit(AddOrderLoading());

    final order = OrderRequestModel(
      height: height,
      weight: weight,
      size: size,
      description: description,
      executionTime: executionTime,
      fabrics: fabrics,
      imagePath: imagePath,
    );

    final result = await addOrderUseCase(order);

    result.fold(
      (failure) => emit(AddOrderError(failure.message)),
      (data) {
        if (!isClosed) {
          emit(AddOrderSuccess(data));
        }
      },
    );
  }
}
