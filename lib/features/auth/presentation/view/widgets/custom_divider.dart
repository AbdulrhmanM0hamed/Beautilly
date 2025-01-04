
import 'package:beautilly/core/utils/constant/app_strings.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/font_manger.dart';


class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const  Expanded(child: Divider(color: AppColors.grey)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            AppStrings.or,
            style: getSemiBoldStyle(fontFamily: FontConstant.cairo, fontSize: FontSize.size18, color: AppColors.textPrimary),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.grey)),
      ],
    );
  }
}
