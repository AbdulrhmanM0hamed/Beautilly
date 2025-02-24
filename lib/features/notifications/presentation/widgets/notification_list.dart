import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification.dart';
import '../cubit/notifications_cubit.dart';
import 'notification_item.dart';

class NotificationList extends StatefulWidget {
  final List<NotificationEntity> notifications;
  final PaginationEntity pagination;

  const NotificationList({
    Key? key,
    required this.notifications,
    required this.pagination,
  }) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isLoadingMore &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreNotifications();
    }
  }

  Future<void> _loadMoreNotifications() async {
    final notificationsCubit = context.read<NotificationsCubit>();
    if (notificationsCubit.hasMorePages && !_isLoadingMore) {
      setState(() => _isLoadingMore = true);
      await notificationsCubit.loadMoreNotifications();
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: widget.notifications.length + 1, // +1 للـ loading indicator
      itemBuilder: (context, index) {
        if (index == widget.notifications.length) {
          // عرض loading indicator في نهاية القائمة
          if (_isLoadingMore) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          // عرض رسالة عند الوصول لنهاية القائمة
          if (widget.pagination.currentPage == widget.pagination.lastPage) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'لا يوجد المزيد من الإشعارات',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        final notification = widget.notifications[index];
        return NotificationItem(notification: notification);
      },
    );
  }
} 