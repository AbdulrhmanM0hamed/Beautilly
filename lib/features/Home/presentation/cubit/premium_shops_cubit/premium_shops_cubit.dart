import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/get_premium_shops_usecase.dart';
import 'premium_shops_state.dart';

class PremiumShopsCubit extends Cubit<PremiumShopsState> {
  final GetPremiumShopsUseCase getPremiumShopsUseCase;

  PremiumShopsCubit({
    required this.getPremiumShopsUseCase,
  }) : super(PremiumShopsInitial());

  Future<void> loadPremiumShops({int page = 1, bool isLoadingMore = false}) async {
    if (!isLoadingMore) {
      emit(PremiumShopsLoading());
    }

    final result = await getPremiumShopsUseCase(page);
    
    result.fold(
      (failure) {
        emit(PremiumShopsError(failure.message));
      },
      (shops) {
        emit(PremiumShopsLoaded(shops));
      },
    );
  }
} 