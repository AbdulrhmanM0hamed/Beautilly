import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';
import '../../domain/entities/notification.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NotificationsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NotificationsResponseEntity>> getNotifications({int page = 1}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت'
      ));
    }

    try {
      final response = await remoteDataSource.getNotifications(page: page);
      return Right(NotificationsResponseEntity(
        notifications: response.notifications.map((notification) => 
          NotificationEntity(
            id: notification.id,
            type: notification.type,
            message: notification.message,
            reservationId: notification.reservationId,
            orderId: notification.orderId,
            read: notification.read,
            readAt: notification.readAt != null ? DateTime.parse(notification.readAt!) : null,
            createdAt: DateTime.parse(notification.createdAt),
            status: notification.status,
          )
        ).toList(),
        unreadCount: response.unreadCount,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure(
        message: 'حدث خطأ غير متوقع'
      ));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت'
      ));
    }

    try {
      await remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure(
        message: 'حدث خطأ غير متوقع'
      ));
    }
  }

  @override
  Future<Either<Failure, void>> DeleteNorifications() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'لا يوجد اتصال بالإنترنت'
      ));
    }

    try {
      await remoteDataSource.DeleteNorifications();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure(
        message: 'حدث خطأ في حذف الإشعارات'
      ));
    }
  }
} 