import 'package:equatable/equatable.dart';
import '../../domain/entities/notification.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoadingMore extends NotificationsState {
  final List<NotificationEntity> currentNotifications;
  final PaginationEntity currentPagination;

  NotificationsLoadingMore({
    required this.currentNotifications,
    required this.currentPagination,
  });
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final PaginationEntity pagination;
  final String? fcmToken;

  NotificationsLoaded({
    required this.notifications,
    required this.pagination,
    this.fcmToken,
  });
}

class NotificationsError extends NotificationsState {
  final String message;

  NotificationsError(this.message);
}

class NotificationMarkedAsRead extends NotificationsState {
  final String notificationId;

  NotificationMarkedAsRead(this.notificationId);
} 