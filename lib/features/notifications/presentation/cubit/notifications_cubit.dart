import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_notifications.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotifications;

  NotificationsCubit({
    required this.getNotifications,
  }) : super(NotificationsInitial());

  Future<void> loadNotifications({int page = 1}) async {
    emit(NotificationsLoading());
    
    final result = await getNotifications(page: page);
    
    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (response) {
        emit(NotificationsLoaded(
          notifications: response.notifications,
          unreadCount: response.unreadCount,
        ));
      },
    );
  }

} 