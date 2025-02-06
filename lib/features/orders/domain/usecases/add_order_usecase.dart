import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/order_request_model.dart';
import '../repositories/orders_repository.dart';

class AddOrderUseCase {
  final OrdersRepository repository;

  AddOrderUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(OrderRequestModel order) {
    return repository.addOrder(order);
  }
} 