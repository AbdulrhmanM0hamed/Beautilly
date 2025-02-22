import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotifications;
  final MarkNotificationAsReadUseCase markAsRead;

  NotificationsCubit({
    required this.getNotifications,
    required this.markAsRead,
  }) : super(NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());
    
    final result = await getNotifications();
    
    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (notifications) => emit(NotificationsLoaded(notifications)),
    );
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final result = await markAsRead(notificationId);
    
    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (_) {
        emit(NotificationMarkedAsRead(notificationId));
        loadNotifications();  // إعادة تحميل القائمة
      },
    );
  }
} 