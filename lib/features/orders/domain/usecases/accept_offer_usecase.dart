import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/orders_repository.dart';

class AcceptOfferUseCase {
  final OrdersRepository repository;

  AcceptOfferUseCase(this.repository);

  Future<Either<Failure, void>> call(int orderId, int offerId) {
    return repository.acceptOffer(orderId, offerId);
  }
} 