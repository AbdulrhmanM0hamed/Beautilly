import 'package:beautilly/features/notifications/domain/entities/notification.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required String id,
    required String type,
    required NotificationDataModel data,
    DateTime? readAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          type: type,
          data: data,
          readAt: readAt,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      data: NotificationDataModel.fromJson(json['data']),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class NotificationDataModel extends NotificationData {
  NotificationDataModel({
    required String message,
    int? reservationId,
    required String status,
    required DateTime timestamp,
    required bool read,
    required String fcmToken,
  }) : super(
          message: message,
          reservationId: reservationId,
          status: status,
          timestamp: timestamp,
          read: read,
          fcmToken: fcmToken,
        );

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
      message: json['message'],
      reservationId: json['reservation_id'],
      status: json['status'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      read: json['read'] ?? false,
      fcmToken: json['fcm_token'],
    );
  }
} 