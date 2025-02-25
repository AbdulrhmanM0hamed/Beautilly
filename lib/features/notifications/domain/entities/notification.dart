class NotificationEntity {
  final String id;
  final String type;
  final String message;
  final int? reservationId;
  final int? orderId;
  final bool read;
  final DateTime? readAt;
  final DateTime createdAt;
  final String status;

  NotificationEntity({
    required this.id,
    required this.type,
    required this.message,
    this.reservationId,
    this.orderId,
    required this.read,
    this.readAt,
    required this.createdAt,
    required this.status,
  });
}

class NotificationDataEntity {
  final String message;
  final int? reservationId;
  final int? orderId;
  final String status;
  final DateTime timestamp;
  final bool read;

  NotificationDataEntity({
    required this.message,
    this.reservationId,
    this.orderId,
    required this.status,
    required this.timestamp,
    required this.read,
  });
}

class PaginationEntity {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationEntity({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class NotificationsResponseEntity {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  NotificationsResponseEntity({
    required this.notifications,
    required this.unreadCount,
  });
} 