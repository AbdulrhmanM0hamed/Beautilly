// lib/features/orders/presentation/cubit/cancel_offer_cubit/cancel_offer_cubit.dart

import 'package:beautilly/features/orders/presentation/cubit/cancel_offer_cubit/cancel_offer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/features/orders/domain/usecases/cancel_offer_usecase.dart';

class CancelOfferCubit extends Cubit<CancelOfferState> {
  final CancelOfferUseCase cancelOfferUseCase;

  CancelOfferCubit({required this.cancelOfferUseCase})
      : super(CancelOfferInitial());

  Future<void> cancelOffer(int orderId, int offerId) async {
    emit(CancelOfferLoading());
    final result = await cancelOfferUseCase(orderId, offerId);
    emit(result.fold(
      (failure) => CancelOfferError(failure.message),
      (_) => CancelOfferSuccess(offerId: offerId),
    ));
  }
}
