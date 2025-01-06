import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeTextWidget extends StatelessWidget {
  const WelcomeTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            text: 'مرحبا, ',
            style: getBoldStyle(
              color: AppColors.black,
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size24,
            ),
            children: [
              TextSpan(
                text: 'عبدو ',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size24,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        CustomSearch(),
      ],
    );
  }
}

class CustomSearch extends StatelessWidget {
  const CustomSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),
      child: Center(
        child: SvgPicture.asset(
          AppAssets.searchIcon,
          height: 24,
          width: 24,
        ),
      ),
    );
  }
}
