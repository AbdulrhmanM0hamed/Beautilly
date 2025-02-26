import 'package:beautilly/core/services/notification/notification_service.dart';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:beautilly/features/orders/presentation/cubit/order_details_cubit/order_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/notifications_cubit.dart';
import '../widgets/notification_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
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
    
    // تحميل الإشعارات عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().loadNotifications();
    });
  }

  Future<void> _markNotificationsAsRead() async {
    // استخدام الدالة المحدثة من NotificationService
    await GetIt.I<NotificationService>().markAllAsRead();
    
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<NotificationsCubit>()..loadNotifications(),
        ),
        BlocProvider(
          create: (context) => sl<OrderDetailsCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'الإشعارات',
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(child: CustomProgressIndcator(
                color: AppColors.primary,
              ));
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
      ),
    );
  }
}