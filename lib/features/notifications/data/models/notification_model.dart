import 'package:beautilly/features/notifications/domain/entities/notification.dart';

class NotificationModel {
  final String id;
  final String type;
  final NotificationData data;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.data,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      data: NotificationData.fromJson(json['data']),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class NotificationData {
  final String message;
  final int reservationId;
  final String status;
  final DateTime timestamp;
  final bool read;
  final String? fcmToken;

  NotificationData({
    required this.message,
    required this.reservationId,
    required this.status,
    required this.timestamp,
    required this.read,
    this.fcmToken,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      message: json['message'],
      reservationId: json['reservation_id'],
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
      read: json['read'] ?? false,
      fcmToken: json['fcm_token'],
    );
  }
}

class NotificationPagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  NotificationPagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory NotificationPagination.fromJson(Map<String, dynamic> json) {
    return NotificationPagination(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }
}

class NotificationsResponse {
  final List<NotificationModel> notifications;
  final NotificationPagination pagination;
  final String? fcmToken;

  NotificationsResponse({
    required this.notifications,
    required this.pagination,
    this.fcmToken,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      notifications: (json['notifications'] as List)
          .map((notification) => NotificationModel.fromJson(notification))
          .toList(),
      pagination: NotificationPagination.fromJson(json['pagination']),
      fcmToken: json['fcm_token'],
    );
  }
} 