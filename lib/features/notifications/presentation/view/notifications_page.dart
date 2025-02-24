import 'package:beautilly/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/notifications_cubit.dart';
import '../widgets/notification_list.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات')),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationsError) {
            return Center(child: Text(state.message));
          }

          if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return const Center(
                child: Text('لا توجد إشعارات'),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<NotificationsCubit>().loadNotifications(),
              child: NotificationList(
                notifications: state.notifications,
                pagination: state.pagination,
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}