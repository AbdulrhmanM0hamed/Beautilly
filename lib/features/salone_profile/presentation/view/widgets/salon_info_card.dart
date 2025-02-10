import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:flutter/material.dart';

class SalonInfoCard extends StatelessWidget {
  final String name;
  final String description;
  final Location location;
  final List<WorkingHour> workingHours;

  const SalonInfoCard({
    super.key,
    required this.name,
    required this.description,
    required this.location,
    required this.workingHours,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size20,
            ),
          ),
          const SizedBox(height: 8),
          
          // Location
          Text(
            '${location.city}، ${location.state}',
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          if (description.isNotEmpty) ...[
            Text(
              'من نحن',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Working Hours
          Text(
            'ساعات العمل',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
            ),
          ),
          const SizedBox(height: 8),
          ...workingHours.map((hour) => _buildWorkingHourRow(
            hour.day,
            '${hour.openingTime} - ${hour.closingTime}',
          )),
        ],
      ),
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
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            hours,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
