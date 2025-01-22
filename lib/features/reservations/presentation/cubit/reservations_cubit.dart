import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_reservations.dart';
import 'reservations_state.dart';

class ReservationsCubit extends Cubit<ReservationsState> {
  final GetMyReservations getMyReservations;

  ReservationsCubit({
    required this.getMyReservations,
  }) : super(ReservationsInitial());

  Future<void> loadMyReservations() async {
    if (isClosed) return;
    emit(ReservationsLoading());
    
    final result = await getMyReservations();
    
    if (isClosed) return;
    result.fold(
      (failure) => emit(ReservationsError(failure.message)),
      (reservations) => emit(ReservationsSuccess(reservations)),
    );
  }
} 