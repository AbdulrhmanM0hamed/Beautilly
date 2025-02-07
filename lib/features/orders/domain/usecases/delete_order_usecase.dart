import 'package:beautilly/core/error/failures.dart';
import 'package:beautilly/features/orders/domain/repositories/orders_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteOrderUseCase {
  final OrdersRepository repository;

  DeleteOrderUseCase(this.repository);

  Future<Either<Failure, void>> call(int orderId) {
    return repository.deleteOrder(orderId);
  }
} 