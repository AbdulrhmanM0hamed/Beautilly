import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notification_list.dart';

import '../widgets/empty_notifications_widget.dart';

class NotificationsPage extends StatelessWidget {
  static const String routeName = '/notifications';

  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const CustomProgressIndcator(
              color: AppColors.primary,
            );
          } else if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return const EmptyNotificationsWidget();
            }
            return NotificationList(notifications: state.notifications);
          } else if (state is NotificationsError) {
            return Text(state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
