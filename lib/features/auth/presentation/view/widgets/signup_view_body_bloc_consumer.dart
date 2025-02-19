import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/auth/presentation/view/signin_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/widgets/custom_snackbar.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';

class SignupViewBodyBlocConsumer extends StatelessWidget {
  const SignupViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          CustomSnackbar.showSuccess(
            context: context,
            message: state.message,
          );
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, SigninView.routeName);
          });
        } else if (state is AuthError) {
          CustomSnackbar.showError(
            context: context,
            message: state.message,
          );
        }
      },
      builder: (context, state) {
        return state is AuthLoading
            ? const Center(
                child: CustomProgressIndcator(
                color: AppColors.primary,
              ))
            : const SizedBox.shrink();
      },
    );
  }
}
