import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/common/custom_text_field.dart';
import 'package:beautilly/core/utils/constant/app_strings.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/validators/form_validators.dart';
import 'package:flutter/material.dart';

class ForgetPasswordViewBody extends StatefulWidget {
  const ForgetPasswordViewBody({super.key});

  @override
  State<ForgetPasswordViewBody> createState() => _ForgetPasswordViewBodyState();
}

class _ForgetPasswordViewBodyState extends State<ForgetPasswordViewBody> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String phoneNumber;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool showPhoneField = false;

  bool _validateEmail(String email) {
    // Simpler email validation that allows more email formats while maintaining basic structure
    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Form(
        key: _formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.resetPassword,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: AppStrings.email,
              suffix: const Icon(Icons.email),
              validator: FormValidators.validateEmail,
              onSaved: (value) => email = value!,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: AppStrings.sendCode,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
