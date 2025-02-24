import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notification.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, NotificationsResponseEntity>> getNotifications({int page = 1});
  Future<Either<Failure, void>> markAsRead(String notificationId);
} 