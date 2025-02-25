class NotificationModel {
  final String id;
  final String type;
  final String message;
  final int? reservationId;
  final int? orderId;
  final bool read;
  final String? readAt;
  final String createdAt;
  final String status;
  final String timestamp;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    this.reservationId,
    this.orderId,
    required this.read,
    this.readAt,
    required this.createdAt,
    required this.status,
    required this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      message: json['message'] ?? '',
      reservationId: json['reservation_id'],
      orderId: json['order_id'],
      read: json['read'] ?? false,
      readAt: json['read_at'],
      createdAt: json['created_at'] ?? '',
      status: json['status'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class NotificationData {
  final String message;
  final int reservationId;
  final String status;
  final String timestamp;
  final bool read;
  final String fcmToken;

  NotificationData({
    required this.message,
    required this.reservationId,
    required this.status,
    required this.timestamp,
    required this.read,
    required this.fcmToken,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      message: json['message'] ?? '',
      reservationId: json['reservation_id'] ?? 0,
      status: json['status'] ?? '',
      timestamp: json['timestamp'] ?? '',
      read: json['read'] ?? false,
      fcmToken: json['fcm_token'] ?? '',
    );
  }
}

class PaginationModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 20,
      total: json['total'] ?? 0,
    );
  }
}

class NotificationsResponse {
  final List<NotificationModel> notifications;
  final int unreadCount;

  NotificationsResponse({
    required this.notifications,
    required this.unreadCount,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      notifications: (json['data'] as List)
          .map((notification) => NotificationModel.fromJson(notification))
          .toList(),
      unreadCount: json['unread_count'] ?? 0,
    );
  }
} 