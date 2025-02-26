import 'package:beautilly/core/services/notification/notification_service.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/notifications_cubit.dart';
import '../widgets/notification_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';

class NotificationsPage extends StatefulWidget {
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // تحديث حالة الإشعارات في Firebase
    _markNotificationsAsRead();
  }

  Future<void> _markNotificationsAsRead() async {
    // استخدام الدالة المحدثة من NotificationService
    await GetIt.I<NotificationService>().markAllAsRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'الإشعارات',
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return const Center(
                child: Text('لا توجد إشعارات'),
              );
            }

            return NotificationList(
              notifications: state.notifications,
            );
          }

          if (state is NotificationsError) {
            return Center(
              child: Text(state.message),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}