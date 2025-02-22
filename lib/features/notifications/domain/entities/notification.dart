import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String type;
  final NotificationData data;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.data,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, type, data, readAt, createdAt, updatedAt];
}

class NotificationData extends Equatable {
  final String message;
  final int? reservationId;
  final String status;
  final DateTime timestamp;
  final bool read;
  final String fcmToken;

  const NotificationData({
    required this.message,
    this.reservationId,
    required this.status,
    required this.timestamp,
    required this.read,
    required this.fcmToken,
  });

  @override
  List<Object?> get props => [message, reservationId, status, timestamp, read, fcmToken];
} 