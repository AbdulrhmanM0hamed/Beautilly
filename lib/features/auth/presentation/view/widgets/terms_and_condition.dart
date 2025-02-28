import 'package:beautilly/core/utils/constant/app_strings.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/profile/presentation/view/terms_and_privacy_view.dart';
import 'package:flutter/material.dart';

class TermsAndConditons extends StatelessWidget {
  const TermsAndConditons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, TermsAndPrivacyView.routeName);
        },
        child: Text.rich(
          TextSpan(
            text: AppStrings.bySigningUp,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.textSecondary,
            ),
            children: [
              TextSpan(
                text: AppStrings.termsOfService,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.start,
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}
