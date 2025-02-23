import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/get_discounts_usecase.dart';
import 'discounts_state.dart';

class DiscountsCubit extends Cubit<DiscountsState> {
  final GetDiscountsUseCase getDiscountsUseCase;

  DiscountsCubit({
    required this.getDiscountsUseCase,
  }) : super(DiscountsInitial());

  Future<void> loadDiscounts() async {
    try {
      emit(DiscountsLoading());

      final result = await getDiscountsUseCase(const NoParams());

      result.fold(
        (failure) {
          emit(DiscountsError(failure.message));
        },
        (discounts) {
          if (discounts.isEmpty) {
            emit(DiscountsError('لا توجد عروض متاحة'));
          } else {
            emit(DiscountsLoaded(discounts));
          }
        },
      );
    } catch (e) {
      emit(DiscountsError(e.toString()));
    }
  }
}
