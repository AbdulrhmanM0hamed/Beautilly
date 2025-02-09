import 'package:beautilly/core/error/failures.dart';
import 'package:beautilly/features/orders/domain/repositories/orders_repository.dart';
import 'package:dartz/dartz.dart';

class CancelOfferUseCase {
  final OrdersRepository repository;

  CancelOfferUseCase(this.repository);

  Future<Either<Failure, void>> call(int orderId, int offerId) {
    return repository.cancelOffer(orderId, offerId);
  }
} 