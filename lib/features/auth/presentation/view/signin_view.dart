import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/signin_view_body.dart';
import 'package:flutter/material.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});
  static const String routeName = "login";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "تسجيل الدخول",
      ),
      body: const SigninViewBody(),
    );
  }
}
