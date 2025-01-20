
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/constant/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/services/service_locator.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/location_cubit.dart';
import 'widgets/signup_view_body.dart';

class SignupView extends StatelessWidget {
  static const routeName = 'SignupView';
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<LocationCubit>(),
        ),
      ],
      child: const Scaffold(
        appBar: CustomAppBar(
        title: AppStrings.register,
      ),
        body: SafeArea(
          child: SignupViewBody(),
        ),
      ),
    );
  }
}
