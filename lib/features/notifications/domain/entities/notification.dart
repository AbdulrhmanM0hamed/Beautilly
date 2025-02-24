import 'package:equatable/equatable.dart';

class NotificationEntity {
  final String id;
  final String type;
  final NotificationDataEntity data;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationEntity({
    required this.id,
    required this.type,
    required this.data,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });
}

class NotificationDataEntity {
  final String message;
  final int reservationId;
  final String status;
  final DateTime timestamp;
  final bool read;

  NotificationDataEntity({
    required this.message,
    required this.reservationId,
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
  final PaginationEntity pagination;
  final String? fcmToken;

  NotificationsResponseEntity({
    required this.notifications,
    required this.pagination,
    this.fcmToken,
  });
} 