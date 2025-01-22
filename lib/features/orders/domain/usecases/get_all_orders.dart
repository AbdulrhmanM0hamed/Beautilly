import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class GetAllOrders {
  final OrdersRepository repository;

  GetAllOrders(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call() async {
    return await repository.getAllOrders();
  }
} 