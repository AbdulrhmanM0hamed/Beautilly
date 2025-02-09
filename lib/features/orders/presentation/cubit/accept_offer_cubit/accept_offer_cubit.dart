import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/accept_offer_usecase.dart';
import 'accept_offer_state.dart';

class AcceptOfferCubit extends Cubit<AcceptOfferState> {
  final AcceptOfferUseCase acceptOfferUseCase;

  AcceptOfferCubit({required this.acceptOfferUseCase}) : super(AcceptOfferInitial());

  Future<void> acceptOffer(int orderId, int offerId) async {
    emit(AcceptOfferLoading());
    final result = await acceptOfferUseCase(orderId, offerId);
    result.fold(
      (failure) => emit(AcceptOfferError(failure.message)),
      (_) => emit(AcceptOfferSuccess()),
    );
  }
} 