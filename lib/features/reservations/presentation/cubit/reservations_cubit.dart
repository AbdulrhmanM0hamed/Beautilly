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
    print('Loading reservations...');

    final result = await getMyReservationsUseCase();
    
    result.fold(
      (failure) {
        print('Error loading reservations: ${failure.message}');
        emit(ReservationsError(failure.message));
      },
      (reservations) {
        print('Loaded ${reservations.length} reservations');
        emit(ReservationsSuccess(reservations));
      },
    );
  }
} 