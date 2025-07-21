import 'package:beautilly/core/services/notification/notification_service.dart';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/common/custom_dialog_button.dart';
import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../cubit/notifications_cubit.dart';
import '../widgets/notification_list.dart';
import 'package:get_it/get_it.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late NotificationsCubit _notificationsCubit;

  @override
  void initState() {
    super.initState();
    _notificationsCubit = sl<NotificationsCubit>();
    _markNotificationsAsRead();
    _notificationsCubit.loadNotifications();
  }

  @override
  void dispose() {
    _notificationsCubit.close();
    super.dispose();
  }

  Future<void> _markNotificationsAsRead() async {
    await GetIt.I<NotificationService>().markAllAsRead();
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف الإشعارات'),
        content: const Text('هل أنت متأكد من حذف جميع الإشعارات؟'),
        actions: [
          CustomDialogButton(
            text: 'إلغاء',
            onPressed: () => Navigator.pop(context),
          ),
          CustomDialogButton(
            text: 'حذف',
            textColor: Colors.white,
            backgroundColor: AppColors.error,
            onPressed: () {
              Navigator.pop(context);
              _notificationsCubit.deleteAllNotifications();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _notificationsCubit,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'الإشعارات',
          actions: [
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state is NotificationsLoaded && state.notifications.isNotEmpty) {
                  return GestureDetector(
                    onTap: () => _showDeleteConfirmationDialog(context),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: SvgPicture.asset(
                        AppAssets.deleteIcon,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocConsumer<NotificationsCubit, NotificationsState>(
          listener: (context, state) {
            if (state is NotificationsDeleted) {
              CustomSnackbar.showSuccess(
                  context: context, message: state.message);
            }
          },
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(
                child: CustomProgressIndcator(
                  color: AppColors.primary,
                ),
              );
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
