import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/common/custom_app_bar.dart';
import '../../../../core/utils/constant/app_strings.dart';
import '../cubit/forgot_password_cubit.dart';
import 'widgets/forget_password_view_body.dart';

class ForgotPasswordView extends StatelessWidget {
  static const String routeName = 'ForgotPasswordView';
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ForgotPasswordCubit>(),
      child: const Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.forgotPassword,
        ),
        body: ForgetPasswordViewBody(),
      ),
    );
  }
}
