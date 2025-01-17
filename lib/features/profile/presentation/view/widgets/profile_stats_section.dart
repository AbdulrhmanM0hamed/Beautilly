import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';

class ProfileStatsSection extends StatelessWidget {
  const ProfileStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('الحجوزات', '12'),
          _buildStatItem('طلبات التفصيل', '5'),
          _buildStatItem('المفضلة', '8'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: getBoldStyle(
            fontSize: FontSize.size20,
            fontFamily: FontConstant.cairo,
          ),
        ),
        Text(
          label,
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
