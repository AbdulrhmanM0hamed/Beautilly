import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';

class CustomMaterialButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomMaterialButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getOfferCardDimensions(context);

    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        height: dimensions.buttonHeight,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.6),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: MaterialButton(
          onPressed: onPressed,
          child: Padding(
            padding: EdgeInsets.only(right: dimensions.horizontalPadding / 3),
            child: Text(
              'احصل على العرض الآن!',
              style: TextStyle(
                color: Colors.white,
                fontSize: dimensions.buttonTextSize,
                fontWeight: FontWeight.bold,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
