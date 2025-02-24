import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../entities/order_details.dart';
import '../../data/models/order_request_model.dart';

abstract class OrdersRepository {
  Future<Either<Failure, OrdersResponse>> getMyOrders({int page = 1});
  Future<Either<Failure, OrdersResponse>> getAllOrders({int page = 1});
  Future<Either<Failure, Map<String, dynamic>>> addOrder(OrderRequestModel order);
  Future<Either<Failure, void>> deleteOrder(int orderId);
  Future<Either<Failure, OrderDetails>> getOrderDetails(int orderId);
  Future<Either<Failure, void>> acceptOffer(int orderId, int offerId);
  Future<Either<Failure, void>> cancelOffer(int orderId, int offerId);
}