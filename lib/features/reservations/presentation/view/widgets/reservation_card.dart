import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:beautilly/features/booking/presentation/cubit/booking_state.dart';
import 'package:beautilly/features/reservations/presentation/cubit/reservations_cubit.dart';
import 'package:beautilly/features/reservations/presentation/view/widgets/status_badge.dart';
import 'package:beautilly/features/salone_profile/presentation/view/salone_profile_view.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../domain/entities/reservation.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../../core/utils/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'shimmer_effect.dart';
import '../../../../../core/utils/responsive/responsive_card_sizes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationCard extends StatelessWidget {
  final ReservationEntity reservation;

  const ReservationCard({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CustomColors>()!;
    final dimensions =
        ResponsiveCardSizes.getReservationCardDimensions(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SalonProfileView(salonId: reservation.shop.id)),
        );
      },
      child: Container(
        width: dimensions.width,
        height: dimensions.height,
        decoration: BoxDecoration(
          color: colors.cardContentBg,
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: dimensions.borderRadius,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
          child: Column(
            children: [
              // Header with Shop Image
              SizedBox(
                height: dimensions.imageHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: reservation.shop.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ShimmerEffect(
                        height: double.infinity,
                        width: double.infinity,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.store_rounded,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha:0.7),
                          ],
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StatusBadge(status: reservation.status),
                              if (reservation.type == 'discount')
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: dimensions.padding,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha:0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.discount_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${(double.parse(reservation.discount?.discountValue.toString() ?? '0')).toInt()}%',
                                        style: getMediumStyle(
                                          color: Colors.white,
                                          fontSize: dimensions.titleSize,
                                          fontFamily: FontConstant.cairo,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const Spacer(),
                          // Shop Info
                          Text(
                            reservation.shop.name,
                            style: getBoldStyle(
                              color: Colors.white,
                              fontSize: dimensions.titleSize,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                reservation.type == 'service'
                                    ? Icons.spa_rounded
                                    : Icons.local_offer_rounded,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                reservation.type == 'service'
                                    ? reservation.service?.name ?? 'خدمة'
                                    : reservation.discount?.title ?? 'عرض',
                                style: getMediumStyle(
                                  
                                  color: Colors.white70,
                                  fontSize: dimensions.subtitleSize,
                                  fontFamily: FontConstant.cairo,
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
              Expanded(
                child: Column(
                  children: [
                    // Time Info
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: dimensions.padding,
                        vertical: dimensions.padding / 3,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTimeInfo(
                              icon: Icons.calendar_today_rounded,
                              label: 'التاريخ',
                              value: _formatDate(reservation.startTime),
                              colors: colors,
                              dimensions: dimensions,
                            ),
                          ),
                          SizedBox(width: dimensions.spacing),
                          Expanded(
                            child: _buildTimeInfo(
                              icon: Icons.access_time_rounded,
                              label: 'الوقت',
                              value: _formatTime(reservation.startTime),
                              colors: colors,
                              dimensions: dimensions,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (reservation.status == 'pending')
                      BlocConsumer<BookingCubit, BookingState>(
                        listener: (context, state) {
                          if (state is CancelAppointmentLoading) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CustomProgressIndcator(
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }

                          if (state is CancelAppointmentSuccess) {
                            Navigator.of(context, rootNavigator: true).pop();
                            context
                                .read<ReservationsCubit>()
                                .getMyReservations();
                            Future.microtask(() {
                              CustomSnackbar.showSuccess(
                                message: 'تم إلغاء الحجز بنجاح',
                                context: context,
                              );
                            });
                          }

                          if (state is CancelAppointmentError) {
                            Navigator.of(context, rootNavigator: true).pop();
                            CustomSnackbar.showError(
                              message: state.message,
                              context: context,
                            );
                          }
                        },
                        builder: (context, state) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: dimensions.padding,
                              right: dimensions.padding,
                              bottom: dimensions.padding / 2,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 28,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                      title: Text(
                                        'تأكيد الإلغاء',
                                        style: getBoldStyle(
                                          fontSize: FontSize.size16,
                                          fontFamily: FontConstant.cairo,
                                        ),
                                      ),
                                      content: Text(
                                        'هل أنت متأكد من إلغاء هذا الحجز؟',
                                        style: getMediumStyle(
                                          fontSize: FontSize.size14,
                                          fontFamily: FontConstant.cairo,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(dialogContext),
                                          child: Text(
                                            'إلغاء',
                                            style: getMediumStyle(
                                              color: Colors.grey,
                                              fontSize: FontSize.size14,
                                              fontFamily: FontConstant.cairo,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(dialogContext);
                                            context
                                                .read<BookingCubit>()
                                                .cancelAppointment(
                                                    reservation.id);
                                          },
                                          child: Text(
                                            'تأكيد',
                                            style: getMediumStyle(
                                              color: Colors.red,
                                              fontSize: FontSize.size14,
                                              fontFamily: FontConstant.cairo,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 245, 57, 75),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'إلغاء',
                                  style: getMediumStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: dimensions.subtitleSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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

  Widget _buildTimeInfo({
    required IconData icon,
    required String label,
    required String value,
    required CustomColors colors,
    required ReservationCardDimensions dimensions,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(dimensions.padding / 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(dimensions.borderRadius / 2),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: dimensions.iconSize,
          ),
        ),
        SizedBox(width: dimensions.spacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getRegularStyle(
                  color: colors.textSecondary,
                  fontSize: dimensions.subtitleSize,
                  fontFamily: FontConstant.cairo,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: getBoldStyle(
                  color: colors.textPrimary,
                  fontSize: dimensions.titleSize,
                  fontFamily: FontConstant.cairo,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    return intl.DateFormat('MM/dd/yy', 'en').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return intl.DateFormat('hh:mm a').format(dateTime);
  }
}
