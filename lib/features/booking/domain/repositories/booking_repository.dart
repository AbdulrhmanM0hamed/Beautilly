import 'package:beautilly/features/booking/domain/entities/available_time.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class BookingRepository {
  Future<Either<Failure, void>> bookService({
    required int shopId,
    required int serviceId,
    required int dayId,
    required int timeId,
  });

  Future<Either<Failure, void>> bookDiscount({
    required int shopId,
    required int discountId,
    required int dayId,
    required int timeId,
  });

  Future<Either<Failure, List<AvailableDate>>> getAvailableDates(int shopId);

  Future<Either<Failure, void>> cancelAppointment(int appointmentId);
} 