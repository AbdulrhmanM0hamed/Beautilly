import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../entities/order_details.dart';
import '../../data/models/order_request_model.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> getMyOrders();
//  Future<Either<Failure, List<OrderEntity>>> getMyReservations();
  Future<Either<Failure, List<OrderEntity>>> getAllOrders();
  Future<Either<Failure, Map<String, dynamic>>> addOrder(OrderRequestModel order);
  Future<Either<Failure, void>> deleteOrder(int orderId);
  Future<Either<Failure, OrderDetails>> getOrderDetails(int orderId);
} 