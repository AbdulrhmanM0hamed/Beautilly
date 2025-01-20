import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../../../../core/utils/common/custom_button.dart';
import '../../../../../core/utils/common/custom_text_field.dart';
import '../../../../../core/utils/constant/app_strings.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../../../core/utils/validators/form_validators.dart';
import '../../../../../core/utils/widgets/custom_snackbar.dart';
import '../../cubit/forgot_password_cubit.dart';
import '../../cubit/forgot_password_state.dart';
import 'package:flutter/widgets.dart';
import '../../../../../features/auth/presentation/view/signin_view.dart';

class ForgetPasswordViewBody extends StatefulWidget {
  const ForgetPasswordViewBody({super.key});

  @override
  State<ForgetPasswordViewBody> createState() => _ForgetPasswordViewBodyState();
}

class _ForgetPasswordViewBodyState extends State<ForgetPasswordViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          Future.microtask(() async {
            CustomSnackbar.showSuccess(
              context: context,
              message: state.message,
            );
            await Future.delayed(const Duration(seconds: 3));
            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed(SigninView.routeName);
            }
          });
        } else if (state is ForgotPasswordError) {
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
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                autovalidateMode: autovalidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      AppStrings.forgotPasswordDesc,
                      textAlign: TextAlign.center,
                      style: getMediumStyle(
                        color: AppColors.grey,
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      controller: _emailController,
                      label: AppStrings.email,
                      suffix: const Icon(Icons.email),
                      validator: FormValidators.validateEmail,
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: AppStrings.sendResetLink,
                      onPressed: state is ForgotPasswordLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<ForgotPasswordCubit>()
                                    .forgotPassword(
                                        _emailController.text.trim());
                              } else {
                                setState(() {
                                  autovalidateMode = AutovalidateMode.always;
                                });
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),
            if (state is ForgotPasswordLoading)
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
    );
  }
}
