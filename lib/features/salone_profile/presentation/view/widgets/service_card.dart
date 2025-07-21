import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:beautilly/features/booking/presentation/widgets/booking_dialog.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final int shopId;

  const ServiceCard({
    super.key,
    required this.service,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: sl<CacheService>().isGuestMode(),
      builder: (context, snapshot) {
        final bool isGuest = snapshot.data ?? false;
        
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha:0.08),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // صورة الخدمة
              Container(
                width: 100,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.1),
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: service.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[100],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // تفاصيل الخدمة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: getBoldStyle(
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                    Text(
                      '${service.price} ر.س',
                      style: getBoldStyle(
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // زر الحجز
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _handleBooking(context, isGuest),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha:0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha:0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'حجز',
                            style: getMediumStyle(
                              color: Colors.white,
                              fontSize: FontSize.size14,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleBooking(BuildContext context, bool isGuest) {
    if (isGuest) {
      CustomSnackbar.showError(
        context: context,
        message: 'يرجى تسجيل الدخول للتمكن من حجز الخدمات',
      );
      return;
    }

    _showBookingDialog(context);
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => sl<BookingCubit>(),
        child: BookingDialog(
          serviceDescription: service.description,
          shopId: shopId,
          serviceId: service.id,
          serviceName: service.name,
          servicePrice: service.price,
        ),
      ),
    );
  }
}

class ServiceModel {
  final String name;
  final String image;
  final double price;
  final double? discount;

  ServiceModel({
    required this.name,
    required this.image,
    required this.price,
    this.discount,
  });
}
