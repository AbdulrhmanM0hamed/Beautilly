import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        height: size.height * 0.04, // 4% of screen height
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.6),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: MaterialButton(
          onPressed: () {},
          child: Padding(
            padding: EdgeInsets.only(right: size.width * 0.025), // 2.5% of screen width
            child: Text(
              'احصل على العرض الآن!',
              style: getBoldStyle(
                color: Colors.white,
                fontSize: size.width * 0.035, // 3.5% of screen width
                fontFamily: FontConstant.cairo,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
