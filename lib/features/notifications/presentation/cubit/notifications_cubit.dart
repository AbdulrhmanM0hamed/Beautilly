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

  Future<void> loadNotifications({int page = 1}) async {
    if (page == 1) {
      emit(NotificationsLoading());
    } else {
      emit(NotificationsLoadingMore(
        currentNotifications: (state as NotificationsLoaded).notifications,
        currentPagination: (state as NotificationsLoaded).pagination,
      ));
    }
    
    final result = await getNotifications(page: page);
    
    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (response) {
        if (page == 1) {
          emit(NotificationsLoaded(
            notifications: response.notifications,
            pagination: response.pagination,
            fcmToken: response.fcmToken,
          ));
        } else {
          final currentState = state as NotificationsLoaded;
          emit(NotificationsLoaded(
            notifications: [
              ...currentState.notifications,
              ...response.notifications,
            ],
            pagination: response.pagination,
            fcmToken: response.fcmToken,
          ));
        }
      },
    );
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final result = await markAsRead(notificationId);
    
    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (_) {
        emit(NotificationMarkedAsRead(notificationId));
        loadNotifications();
      },
    );
  }

  bool get hasMorePages {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      return currentState.pagination.currentPage < currentState.pagination.lastPage;
    }
    return false;
  }

  Future<void> loadMoreNotifications() async {
    if (state is NotificationsLoaded && hasMorePages) {
      final currentState = state as NotificationsLoaded;
      await loadNotifications(page: currentState.pagination.currentPage + 1);
    }
  }
} 