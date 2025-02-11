import 'package:beautilly/features/salone_profile/presentation/view/widgets/outline_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';

class SalonDiscountsSection extends StatelessWidget {
  final List<Discount> discounts;

  const SalonDiscountsSection({
    super.key,
    required this.discounts,
  });

  @override
  Widget build(BuildContext context) {
    if (discounts.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: OutlineWithIcon(
              icon: Icons.local_offer_rounded,
              title: 'العروض والخصومات',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: discounts.length,
              itemBuilder: (context, index) {
                final discount = discounts[index];
                final validUntil = discount.validUntil;
                final daysLeft = validUntil.difference(DateTime.now()).inDays;

                return Container(
                  width: 280,
                  margin: EdgeInsets.only(
                    right: index == 0 ? 0 : 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.success.withOpacity(.9),
                        AppColors.success.withOpacity(.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // زخارف الخلفية
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        left: -20,
                        bottom: -20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      // المحتوى
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12 , vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // نسبة الخصم والسعر
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        discount.discountValue,
                                        style: getBoldStyle(
                                          fontFamily: FontConstant.cairo,
                                          fontSize: FontSize.size14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        '% خصم',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${double.parse(discount.pricing.originalPrice).toStringAsFixed(0)} ر.س',
                                      style: TextStyle(
                                        fontFamily: FontConstant.cairo,
                                        fontSize: FontSize.size14,
                                        color: Colors.white.withOpacity(0.6),
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    Text(
                                      '${double.parse(discount.pricing.finalPrice).toStringAsFixed(0)} ر.س',
                                      style: getBoldStyle(
                                        fontFamily: FontConstant.cairo,
                                        fontSize: FontSize.size16,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            // الخدمات المشمولة
                            if (discount.services.isNotEmpty) ...[
                              Text(
                                discount.title,
                                style: getMediumStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size12,
                                  color: AppColors.accent,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                'يشمل:',
                                style: getMediumStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size12,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              ...discount.services.take(2).map(
                                    (service) => Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            service.name,
                                            style: getMediumStyle(
                                              fontFamily: FontConstant.cairo,
                                              fontSize: FontSize.size12,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              if (discount.services.length > 2)
                                Text(
                                  '...والمزيد',
                                  style: getMediumStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: FontSize.size11,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                            ],
                            const SizedBox(height: 12),
                            // الصف السفلي: الوقت المتبقي وزر الحجز
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.timer_outlined,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'متبقي $daysLeft يوم',
                                        style: getMediumStyle(
                                          fontFamily: FontConstant.cairo,
                                          fontSize: FontSize.size11,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.local_offer_outlined,
                                        color: AppColors.black,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'احجز الآن',
                                        style: getMediumStyle(
                                          fontFamily: FontConstant.cairo,
                                          fontSize: FontSize.size12,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
