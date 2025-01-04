
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/auth/presentation/view/signup_view.dart';
import 'package:flutter/material.dart';


class DontHaveAccount extends StatelessWidget {
  const DontHaveAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textAlign: TextAlign.center,
          "لا تمتلك حساب ؟",
          style: getSemiBoldStyle(fontFamily: FontConstant.cairo, fontSize: FontSize.size16, color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SignupView.routeName);
          },
          child: Text(
            textAlign: TextAlign.center,
            "سجل الان",
            style: getSemiBoldStyle(fontFamily: FontConstant.cairo, fontSize: FontSize.size17, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}



