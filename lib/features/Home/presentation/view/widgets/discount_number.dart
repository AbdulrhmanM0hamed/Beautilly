import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';

class DiscountNumber extends StatelessWidget {
  final int discount;
  const DiscountNumber({super.key, required this.discount});

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getOfferCardDimensions(context);
    
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: dimensions.descriptionSize,
                      fontWeight: FontWeight.normal,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  Text(
                    '$discount%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: dimensions.titleSize,
                      fontWeight: FontWeight.bold,
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
