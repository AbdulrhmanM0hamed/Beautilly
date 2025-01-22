import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class GetMyOrders {
  final OrdersRepository repository;

  GetMyOrders(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call() async {
    return await repository.getMyOrders();
  }
} 