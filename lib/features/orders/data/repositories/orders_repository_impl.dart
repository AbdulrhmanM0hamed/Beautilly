import 'dart:io';
import 'package:beautilly/core/services/network/network_info.dart';
import 'package:beautilly/features/orders/domain/entities/order.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order_details.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_datasource.dart';
import '../models/order_request_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OrdersResponse>> getMyOrders({int page = 1}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final result = await remoteDataSource.getMyOrders(page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  // @override
  // Future<Either<Failure, List<OrderEntity>>> getMyReservations() async {
  //   try {
  //     final reservations = await remoteDataSource.getMyReservations();
  //     return Right(reservations);
  //   } on UnauthorizedException catch (e) {
  //     return Left(AuthFailure(e.message));
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message));
  //   } catch (e) {
  //     return Left(ServerFailure('حدث خطأ غير متوقع'));
  //   }
  // }

  @override
  Future<Either<Failure, OrdersResponse>> getAllOrders({int page = 1}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final result = await remoteDataSource.getAllOrders(page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> addOrder(OrderRequestModel order) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final result = await remoteDataSource.addOrder(order);
      return Right(result);
    } on ServerException catch (e) {
      // تحسين رسائل الخطأ
      if (e.message.contains('صورة')) {
        return Left(ServerFailure(message: 'حجم الصورة كبير جداً، يرجى تقليل حجم الصورة'));
      } else if (e.message.contains('قماش')) {
        return Left(ServerFailure(message: 'يرجى التأكد من إدخال معلومات الأقمشة بشكل صحيح'));
      }
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      // طباعة الخطأ للتتبع
      debugPrint('Error in addOrder: $e');
      return Left(ServerFailure(message: 'حدث خطأ: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(int orderId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      await remoteDataSource.deleteOrder(orderId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return  const Left(ServerFailure(message: 'حدث خطأ أثناء حذف الطلب'));
    }
  }

  @override
  Future<Either<Failure, OrderDetails>> getOrderDetails(int orderId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      final orderDetails = await remoteDataSource.getOrderDetails(orderId);
      return Right(orderDetails);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, void>> acceptOffer(int orderId, int offerId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      await remoteDataSource.acceptOffer(orderId, offerId);
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ أثناء قبول العرض'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelOffer(int orderId, int offerId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى'
      ));
    }

    try {
      await remoteDataSource.cancelOffer(orderId, offerId);
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on SocketException {
      return const Left(NetworkFailure(
        message: 'لا يمكن الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'
      ));
    } catch (e) {
      return const Left(ServerFailure(message: 'حدث خطأ أثناء رفض العرض'));
    }
  }
}
