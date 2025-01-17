import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/common/custom_text_field.dart';
import 'package:beautilly/core/utils/common/password_field.dart';
import 'package:beautilly/core/utils/constant/app_strings.dart';
import 'package:beautilly/core/utils/validators/form_validators.dart';
import 'package:beautilly/features/Home/presentation/view/home_view.dart';
import 'package:beautilly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:beautilly/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:beautilly/features/auth/presentation/cubit/auth_state.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/dont_have_account.dart';
import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';

class SigninViewBodyBlocConsumer extends StatefulWidget {
  const SigninViewBodyBlocConsumer({super.key});

  @override
  State<SigninViewBodyBlocConsumer> createState() =>
      _SigninViewBodyBlocConsumerState();
}

class _SigninViewBodyBlocConsumerState
    extends State<SigninViewBodyBlocConsumer> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthRepositoryImpl()),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, HomeView.routeName);
            CustomSnackbar.showSuccess(
              context: context,
              message: state.message,
            );
          } else if (state is AuthError) {
            CustomSnackbar.showError(
              context: context,
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        CustomTextField(
                          controller: _emailController,
                          label: AppStrings.email,
                          suffix: const Icon(Icons.email),
                          validator: FormValidators.validateEmail,
                        ),
                        const SizedBox(height: 16),
                        PasswordField(
                          validator: FormValidators.validatePasswordLogin,
                          controller: _passwordController,
                          hintText: AppStrings.password,
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 32),
                        CustomButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().login(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                        );
                                  }
                                },
                          text: state is AuthLoading
                              ? 'جاري التحميل...'
                              : AppStrings.login,
                        ),
                        const SizedBox(height: 16),
                        const DontHaveAccount(),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is AuthLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CustomProgressIndcator(
                      size: 50.0,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
