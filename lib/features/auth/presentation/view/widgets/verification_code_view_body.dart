import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationCodeViewBody extends StatelessWidget {
  final String email;
  const VerificationCodeViewBody({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final fieldWidth = screenWidth * 0.11;
    final spacing = screenWidth * 0.01;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'أدخل كود التحقق',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Text(
            'تم إرسال كود التحقق إلى $email',
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: screenWidth * 0.035,
                color: AppColors.grey),
          ),
          SizedBox(height: size.height * 0.04),
          Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                controller: codeController,
                animationType: AnimationType.fade,
                mainAxisAlignment: MainAxisAlignment.center,
                onCompleted: (code) {},
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: fieldWidth,
                  fieldWidth: fieldWidth,
                  fieldOuterPadding: EdgeInsets.symmetric(horizontal: spacing),
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  activeColor: AppColors.white,
                  inactiveColor: Colors.grey,
                  selectedColor: AppColors.secondary,
                ),
                cursorColor: AppColors.primary,
                animationDuration: const Duration(milliseconds: 250),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          CustomButton(
            text: 'تحقق',
            onPressed: () {},
          ),
          SizedBox(height: size.height * 0.02),
          TextButton(
            onPressed: () {},
            child: Text(
              'إعادة إرسال الكود',
              style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: screenWidth * 0.045,
                  color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
