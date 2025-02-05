import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/entities/discount.dart';
import '../../../domain/usecases/get_discounts_usecase.dart';
import 'discounts_state.dart';

class DiscountsCubit extends Cubit<DiscountsState> {
  final GetDiscountsUseCase getDiscountsUseCase;

  DiscountsCubit({
    required this.getDiscountsUseCase,
  }) : super(DiscountsInitial());

  Future<void> loadDiscounts() async {
    emit(DiscountsLoading());

    final result = await getDiscountsUseCase(const NoParams());

    emit(
      result.fold(
        (failure) => DiscountsError(failure.message),
        (discounts) => DiscountsLoaded(discounts),
      ),
    );
  }
} 