import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/forget_password_view_body.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});
  static const String routeName = "forgotPassword";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: "نسيت كلمة المرور",
      ),
      body:  ForgetPasswordViewBody(),
    );
  }
}
