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
  final int unreadCount;

  NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
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

class NotificationsDeleted extends NotificationsState {
  final String message;

  NotificationsDeleted(this.message);
} 