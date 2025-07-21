import 'package:beautilly/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_notifications.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotifications;
  final NotificationsRepository repository;

  NotificationsCubit({
    required this.getNotifications,
    required this.repository,
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

  Future<void> deleteAllNotifications() async {
    emit(NotificationsLoading());
    
    final result = await repository.deleteNorifications();
    
    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (_) {
        emit(NotificationsDeleted('تم حذف جميع الإشعارات بنجاح'));
        loadNotifications();
      },
    );
  }
} 