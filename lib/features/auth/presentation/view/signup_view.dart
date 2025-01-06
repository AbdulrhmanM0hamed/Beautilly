import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/constant/app_strings.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/signup_view_body.dart';
import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  static const routeName = 'SignupView';
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return const  Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.register,
      ),
      body: SignupViewBody(),
    );
  }
}
