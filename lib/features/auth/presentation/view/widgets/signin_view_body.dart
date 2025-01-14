import 'package:beautilly/core/utils/animations/custom_animations.dart';
import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/common/custom_text_field.dart';
import 'package:beautilly/core/utils/common/password_field.dart';
import 'package:beautilly/core/utils/constant/app_strings.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/core/utils/validators/form_validators.dart';
import 'package:beautilly/features/Home/presentation/view/home_view.dart';
import 'package:beautilly/features/auth/presentation/view/forget_password.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/custom_divider.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/dont_have_account.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/socail_button.dart';
import 'package:flutter/material.dart';

class SigninViewBody extends StatefulWidget {
  const SigninViewBody({super.key});

  @override
  State<SigninViewBody> createState() => _SigninViewBodyState();
}

class _SigninViewBodyState extends State<SigninViewBody> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  void _submitForm() {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pushNamed(
        context,
        HomeView.routeName,
      );

      // TODO: Implement sign in logic
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.04,
          horizontal: size.width * 0.05,
        ),
        child: Form(
          key: _formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomAnimations.slideFromTop(
                duration: const Duration(milliseconds: 800),
                child: CustomTextField(
                  label: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  prefix: const Icon(Icons.email),
                  validator: FormValidators.validateEmail,
                  onSaved: (value) => email = value!,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              CustomAnimations.slideFromTop(
                duration: const Duration(milliseconds: 900),
                child: PasswordField(
                  hintText: AppStrings.password,
                  onSaved: (value) => password = value!,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              CustomAnimations.fadeIn(
                duration: const Duration(milliseconds: 1000),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ForgotPasswordView.routeName,
                    );
                  },
                  child: Text(
                    AppStrings.forgotPassword,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: size.height * 0.016,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              CustomAnimations.fadeIn(
                duration: const Duration(milliseconds: 1100),
                child: CustomButton(
                  text: AppStrings.login,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      HomeView.routeName,
                    );
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              CustomAnimations.fadeIn(
                duration: const Duration(milliseconds: 1200),
                child: const CustomDivider(),
              ),
              SizedBox(height: size.height * 0.02),
              CustomAnimations.slideFromBottom(
                duration: const Duration(milliseconds: 1300),
                child: Column(
                  children: [
                    SocialButton(
                      onPressed: () {},
                      iconPath: "assets/icons/google_icon.svg",
                      buttonText: "تسجيل بواسطة Google",
                    ),
                    SizedBox(height: size.height * 0.015),

                    // Platform.isIOS  ?
                    //   SocialButton(
                    //     onPressed: () {
                    //       context.read<SignInCubit>().signInWithApple();
                    //     },
                    //     iconPath: AssetsManager.appleIcon,
                    //     buttonText: "تسجيل بواسطة Apple",
                    //   ) :
                    //   Tooltip(
                    //     message: 'متوفر فقط على أجهزة iOS',
                    //     child: Opacity(
                    //       opacity: 0.5,
                    //       child: SocialButton(
                    //         onPressed: () {},
                    //         iconPath: AssetsManager.appleIcon,
                    //         buttonText: "تسجيل بواسطة Apple ",
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.01),
              CustomAnimations.fadeIn(
                duration: const Duration(milliseconds: 1400),
                child: const DontHaveAccount(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
