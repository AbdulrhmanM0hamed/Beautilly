import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_reservations.dart';
import 'reservations_state.dart';

class ReservationsCubit extends Cubit<ReservationsState> {
  final GetMyReservations  getMyReservationsUseCase;

  ReservationsCubit({
    required this.getMyReservationsUseCase,
  }) : super(ReservationsInitial());

  Future<void> getMyReservations() async {
    emit(ReservationsLoading());

    final result = await getMyReservationsUseCase();
    
    result.fold(
      (failure) {
        emit(ReservationsError(failure.message));
      },
      (reservations) {
        emit(ReservationsSuccess(reservations));
      },
    );
  }
} 