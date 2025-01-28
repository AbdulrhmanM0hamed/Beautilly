import 'package:flutter/material.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../domain/entities/reservation.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../../core/utils/theme/app_theme.dart';

class ReservationCard extends StatelessWidget {
  final ReservationEntity reservation;

  const ReservationCard({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CustomColors>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colors.cardContentBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // التفاصيل
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.cardHeaderBg,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    // Shop Logo
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.cardContentBg,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        reservation.shop.name[0].toUpperCase(),
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          color: AppColors.primary,
                          fontSize: FontSize.size18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Shop Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reservation.shop.name,
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              color: colors.textPrimary,
                              fontSize: FontSize.size16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.spa_outlined,
                                size: 14,
                                color: AppColors.primary.withOpacity(0.7),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  reservation.service.name,
                                  style: getRegularStyle(
                                    fontFamily: FontConstant.cairo,
                                    color: colors.textSecondary,
                                    fontSize: FontSize.size14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(colors),
                  ],
                ),
              ),

              // Time & Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Appointment Time
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.timeContainerBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colors.timeContainerBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildTimeInfo(
                            icon: Icons.access_time_rounded,
                            title: 'وقت البدء',
                            time: reservation.startTime,
                            iconColor: AppColors.primary,
                            colors: colors,
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            color: colors.timeContainerBorder,
                          ),
                          _buildTimeInfo(
                            icon: Icons.timer_outlined,
                            title: 'وقت الانتهاء',
                            time: reservation.endTime,
                            iconColor: Colors.orange,
                            colors: colors,
                          ),
                        ],
                      ),
                    ),

                    // Discount Badge if available
                    if (reservation.discount != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade300,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_offer_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'خصم ${reservation.discount}%',
                              style: getMediumStyle(
                                fontFamily: FontConstant.cairo,
                                color: Colors.white,
                                fontSize: FontSize.size14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Actions for pending reservations
                    if (reservation.status == 'pending') ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildActionButton(
                            onPressed: () {
                              // إلغاء الحجز
                            },
                            icon: Icons.close_rounded,
                            label: 'إلغاء الحجز',
                            color: AppColors.error,
                            isOutlined: true,
                          ),
                          const SizedBox(width: 12),
                          _buildActionButton(
                            onPressed: () {
                              // تعديل الحجز
                            },
                            icon: Icons.edit_calendar_rounded,
                            label: 'تعديل الحجز',
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(CustomColors colors) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (reservation.status) {
      case 'completed':
        statusColor = Colors.green;
        statusText = 'مكتمل';
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'قيد الانتظار';
        statusIcon = Icons.schedule_rounded;
        break;
      case 'confirmed':
        statusColor = AppColors.primary;
        statusText = 'تم التأكيد';
        statusIcon = Icons.schedule_rounded;
        break;
      case 'canceled':
        statusColor = Colors.red;
        statusText = 'ملغي';
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'غير معروف';
        statusIcon = Icons.help_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              color: statusColor,
              fontSize: FontSize.size12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo({
    required IconData icon,
    required String title,
    required DateTime time,
    required Color iconColor,
    required CustomColors colors,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  color: colors.textSecondary,
                  fontSize: FontSize.size12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _formatDateTime(time),
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              color: colors.textPrimary,
              fontSize: FontSize.size14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    bool isOutlined = false,
  }) {
    return Material(
      color: isOutlined ? Colors.transparent : color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isOutlined ? Border.all(color: color) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isOutlined ? color : Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  color: isOutlined ? color : Colors.white,
                  fontSize: FontSize.size14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final date = intl.DateFormat('yyyy/MM/dd').format(dateTime);
    final time = intl.DateFormat('hh:mm a').format(dateTime);
    return '$date\n$time';
  }
}
