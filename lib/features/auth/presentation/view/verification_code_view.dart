import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/verification_code_view_body.dart';
import 'package:flutter/material.dart';

class VerificationCodeView extends StatelessWidget {
  final String email;
  const VerificationCodeView({super.key, required this.email});
  static const String routeName = "verificationCode";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Text(
          'التحقق من البريد الإلكتروني',
          style: getBoldStyle(
              fontFamily: FontConstant.cairo, fontSize: FontSize.size20),
        ),
      ),
      body: VerificationCodeViewBody(email: email),
    );
  }
}
