import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification.dart';
import '../cubit/notifications_cubit.dart';
import 'notification_item.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationEntity> notifications;

  const NotificationList({
    Key? key,
    required this.notifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationItem(notification: notification);
      },
    );
  }
} 