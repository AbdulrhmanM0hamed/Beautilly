import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SalonInfoCard extends StatelessWidget {
  const SalonInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.secondary,
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // قسم "حول"
        Text(
          'من نحن',
          style: getBoldStyle(
              fontFamily: FontConstant.cairo, fontSize: FontSize.size18),
        ),
        const SizedBox(height: 8),
        Text(
          'بلش بيوتي لاونج هو صالون تجميل فاخر يقدم مجموعة واسعة من الخدمات بما في ذلك تصفيف الشعر، علاجات الوجه، العناية بالأظافر والمزيد.',
          style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),

        // ساعات العمل
        Text(
          'ساعات العمل',
          style: getBoldStyle(
              fontFamily: FontConstant.cairo, fontSize: FontSize.size18),
        ),
        const SizedBox(height: 8),
        _buildWorkingHourRow('الأحد - الخميس', '10:00 صباحًا - 10:00 مساءً'),
        _buildWorkingHourRow('الجمعة - السبت', '12:00 ظهرًا - 11:00 مساءً'),
      ]),
    );
  }

  Widget _buildWorkingHourRow(String days, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            days,
            style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: AppColors.textSecondary),
          ),
          Text(
            hours,
            style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
