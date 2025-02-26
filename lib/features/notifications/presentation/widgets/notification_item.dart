import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/features/orders/domain/entities/order_details.dart';
import 'package:beautilly/features/orders/presentation/cubit/order_details_cubit/order_details_state.dart';
import 'package:beautilly/features/orders/presentation/view/order_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification.dart';
import '../cubit/notifications_cubit.dart';
import 'package:beautilly/features/orders/presentation/cubit/order_details_cubit/order_details_cubit.dart';

class NotificationItem extends StatefulWidget {
  final NotificationEntity notification;

  const NotificationItem({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  void initState() {
    super.initState();
    // تحديث حالة الإشعار إلى "مقروء" عند عرضه لأول مرة
    // if (!widget.notification.data.read) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     context
    //         .read<NotificationsCubit>()
    //         .markNotificationAsRead(widget.notification.id);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: widget.notification.read
            ? BorderSide.none
            : BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                width: 1),
      ),
      child: InkWell(
        onTap: () async {
          if (widget.notification.orderId != null) {
            // جلب تفاصيل الطلب أولاً
            await context
                .read<OrderDetailsCubit>()
                .getOrderDetails(widget.notification.orderId!);

            if (context.mounted) {
              final state = context.read<OrderDetailsCubit>().state;
              if (state is OrderDetailsSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsView(
                      orderDetails: state.orderDetails,
                      isMyOrder: true,
                    ),
                  ),
                );
              }
            }
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationIcon(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.notification.message,
                      style: getMediumStyle(
                        fontSize: 15,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (widget.notification.type
                            .contains('ReservationStatusUpdated'))
                          _buildStatusChip(),
                        const Spacer(),
                        Text(
                          _getTimeAgo(widget.notification.createdAt),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    IconData iconData;
    Color iconColor;
    String label;

    switch (widget.notification.type) {
      case 'App\\Notifications\\ReservationStatusUpdated':
        iconData = Icons.event_available;
        iconColor = _getStatusColor(widget.notification.status);
        label = 'حجز';
        break;
      case 'App\\Notifications\\DiscountCreatedNotification':
        iconData = Icons.local_offer;
        iconColor = Colors.purple;
        label = 'عرض';
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.blue;
        label = 'تنبيه';
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, color: iconColor, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: iconColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(widget.notification.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getStatusColor(widget.notification.status),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _getStatusText(widget.notification.status),
            style: TextStyle(
              fontSize: 12,
              color: _getStatusColor(widget.notification.status),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'confirmed':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'مكتمل';
      case 'confirmed':
        return 'تم التأكيد';
      case 'pending':
        return 'قيد الانتظار';
      case 'cancelled':
        return 'ملغى';
      default:
        return status;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} شهر';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}
