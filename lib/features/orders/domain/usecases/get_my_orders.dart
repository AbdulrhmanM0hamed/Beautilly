import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class GetMyOrders {
  final OrdersRepository repository;

  GetMyOrders(this.repository);

  Future<Either<Failure, OrdersResponse>> call({int page = 1}) async {
    return await repository.getMyOrders(page: page);
  }
} 