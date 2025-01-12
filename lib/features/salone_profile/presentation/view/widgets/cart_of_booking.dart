import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/animations/scale_fade_animation.dart';

class CartOfBooking extends StatelessWidget {
  const CartOfBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaleFadeAnimation(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Services Tags
              Wrap(
                spacing: 8,
                children: [
                  buildTag('شعر'),
                  buildTag('وجه'),
                  buildTag('اظافر'),
                  buildTag('2+'),
                ],
              ),
              const SizedBox(height: 12),

              // Salon Name
              Text('صالون الاناقة',
                  style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size20)),
              const SizedBox(height: 8),

              // Address
              Text('شارع التحلية، جدة',
                  style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: AppColors.textSecondary)),
              const SizedBox(height: 12),

              // Rating and Availability
              Row(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.star, color: AppColors.accent),
                      SizedBox(width: 4),
                      Text('4.7 (2.7k)'),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'مفتوح',
                      style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          color: AppColors.white,
                          fontSize: FontSize.size13),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 16),

              // Book Now Button
              const CustomButton(text: "احجزى الان")
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: getBoldStyle(
            fontFamily: FontConstant.cairo, color: AppColors.secondary),
      ),
    );
  }
}
