import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DiscoverFilterChips extends StatelessWidget {
  const DiscoverFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('الكل', true, context),
          _buildFilterChip('صالونات', false, context),
          _buildFilterChip('دور أزياء', false, context),
          _buildFilterChip('مكياج', false, context),
          _buildFilterChip('شعر', false, context),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: FilterChip(
        label: Text(
          label,
          style: getMediumStyle(
            color: isSelected ? Colors.white : AppColors.grey,
            fontSize: FontSize.size12,
            fontFamily: FontConstant.cairo,
          ),
        ),
        selected: isSelected,
        onSelected: (bool value) {
          // Handle filter selection
        },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: const BorderSide(
          color: AppColors.grey,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        pressElevation: 0,
      ),
    );
  }
}
