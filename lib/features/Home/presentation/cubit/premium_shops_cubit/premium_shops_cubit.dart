import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/entities/premium_shop.dart';
import '../../../domain/usecases/get_premium_shops_usecase.dart';
import 'premium_shops_state.dart';

class PremiumShopsCubit extends Cubit<PremiumShopsState> {
  final GetPremiumShopsUseCase getPremiumShopsUseCase;

  PremiumShopsCubit({
    required this.getPremiumShopsUseCase,
  }) : super(PremiumShopsInitial());

  Future<void> loadPremiumShops() async {
    emit(PremiumShopsLoading());

    final result = await getPremiumShopsUseCase(const NoParams());

    emit(
      result.fold(
        (failure) => PremiumShopsError(failure.message),
        (shops) => PremiumShopsLoaded(shops),
      ),
    );
  }
} 