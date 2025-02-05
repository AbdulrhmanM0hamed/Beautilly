import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';

class DiscountNumber extends StatelessWidget {
  final int discount;
  const DiscountNumber({super.key, required this.discount});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleSize = size.width * 0.2;
    
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.06),
      child: Transform.rotate(
        angle: -0.6,
        child: Container(
          width: circleSize,
          height: circleSize,
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
                      fontSize: size.width * 0.035,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  Text(
                    '$discount%',
                    style: getBoldStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.06,
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
