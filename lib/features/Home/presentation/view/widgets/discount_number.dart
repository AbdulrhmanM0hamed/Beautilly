import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';

class DiscountNumber extends StatelessWidget {
  final String value;
  final String type;

  const DiscountNumber({
    super.key,
    required this.value,
    required this.type,
  });

  String _formatValue(String value) {
    // تحويل النص إلى رقم عشري
    final number = double.tryParse(value) ?? 0;
    // تقريب الرقم إلى أقرب رقم صحيح إذا كان الجزء العشري صفر
    return number.truncateToDouble() == number
        ? number.toInt().toString()
        : number.toString();
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getOfferCardDimensions(context);
    final formattedValue = _formatValue(value);

    return Padding(
      padding: EdgeInsets.only(left: dimensions.horizontalPadding),
      child: Transform.rotate(
        angle: -0.6,
        child: Container(
          width: dimensions.discountCircleSize,
          height: dimensions.discountCircleSize,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Transform.rotate(
              angle: 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'حتى',
                    style: getRegularStyle(
                      color: Colors.white,
                      fontSize: dimensions.descriptionSize,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  Text(
                    type == 'fixed'
                        ? '$formattedValue ر.س'
                        : '$formattedValue%',
                    style: getBoldStyle(
                      color: Colors.white,
                      fontSize: dimensions.titleSize,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
