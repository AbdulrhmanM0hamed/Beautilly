import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> getMyOrders();
  Future<Either<Failure, List<OrderEntity>>> getMyReservations();
} 