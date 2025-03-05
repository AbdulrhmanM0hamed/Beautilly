import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
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
    try {
      emit(AddOrderLoading());

      // Log request data in debug mode
      debugPrint('Adding order with fabrics: ${fabrics.length}');
      for (var fabric in fabrics) {
        debugPrint('Fabric type: ${fabric.type}, color: ${fabric.color}');
      }

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

      if (isClosed) {
        debugPrint('Cubit is closed, skipping emit');
        return;
      }

      result.fold(
        (failure) {
          debugPrint('Add order failed: ${failure.message}');
          emit(AddOrderError(failure.message));
        },
        (data) {
          debugPrint('Order added successfully');
          emit(AddOrderSuccess(data));
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Unexpected error in addOrder: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(AddOrderError('حدث خطأ غير متوقع'));
    }
  }
}
