import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/booking_repository.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository repository;

  BookingCubit({required this.repository}) : super(BookingInitial());

  Future<void> bookService({
    required int shopId,
    required int serviceId,
    required int dayId,
    required int timeId,
  }) async {
    emit(BookingLoading());
    try {
      await repository.bookService(
        shopId: shopId,
        serviceId: serviceId,
        dayId: dayId,
        timeId: timeId,
      );
      emit(BookingSuccess('تم الحجز بنجاح'));
    } on ServerFailure catch (failure) {
      emit(BookingError(failure.message));
    } catch (e) {
      emit(BookingError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> bookDiscount({
    required int shopId,
    required int discountId,
    required int dayId,
    required int timeId,
  }) async {
    emit(BookingLoading());
    final result = await repository.bookDiscount(
      shopId: shopId,
      discountId: discountId,
      dayId: dayId,
      timeId: timeId,
    );
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (_) => emit(BookingSuccess('تم حجز العرض بنجاح')),
    );
  }

  Future<void> loadAvailableDates(int shopId) async {
    emit(BookingLoading());
    final result = await repository.getAvailableDates(shopId);
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (dates) => emit(DatesLoaded(dates))
    );
  }

  Future<void> cancelAppointment(int appointmentId) async {
    emit(CancelAppointmentLoading());

    final result = await repository.cancelAppointment(appointmentId);

    result.fold(
      (failure) => emit(CancelAppointmentError(failure.message)),
      (_) => emit(CancelAppointmentSuccess()),
    );
  }
} 