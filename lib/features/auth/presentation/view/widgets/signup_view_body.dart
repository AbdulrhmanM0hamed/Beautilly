import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/common/custom_text_field.dart';
import 'package:beautilly/core/utils/common/password_field.dart';
import 'package:beautilly/core/utils/constant/app_strings.dart';
import 'package:beautilly/core/utils/validators/form_validators.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/custom_check_box.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/hava_an_account.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/terms_and_condition.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/common/location_dropdown.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email, password, userName, phoneNumber;
  bool isAgreed = false;

  String _normalizeSpaces(String value) {
    // Remove leading/trailing spaces and replace multiple spaces with single space
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // String? _validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'البريد الإلكتروني مطلوب';
  //   }

  //   // Check for spaces in email
  //   if (value.contains(' ')) {
  //     return 'لا يمكن أن يحتوي البريد الإلكتروني على مسافات';
  //   }

  //   // تعبير منتظم أكثر مرونة للتحقق من صحة البريد الإلكتروني
  //   final emailRegExp = RegExp(
  //     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  //     caseSensitive: false,
  //   );

  //   if (!emailRegExp.hasMatch(value)) {
  //     return 'البريد الإلكتروني غير صحيح';
  //   }

  //   return null;
  // }

  // String? _validateName(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'الرجاء إدخال اسمك الكامل';
  //   }

  //   // Check if the value contains only spaces
  //   if (value.trim().isEmpty) {
  //     return 'لا يمكن أن يتكون الاسم من مسافات فقط';
  //   }

  //   // Normalize spaces and check length
  //   String normalizedValue = _normalizeSpaces(value);
  //   if (normalizedValue.length < 4) {
  //     return 'الاسم يجب أن يكون 4 أحرف على الأقل';
  //   }

  //   // Ensure the name contains actual letters (Arabic or English) and allows spaces between words
  //   if (!RegExp(r'^[\u0600-\u06FFa-zA-Z\s]+$').hasMatch(normalizedValue)) {
  //     return 'الاسم يجب أن يحتوي على حروف فقط';
  //   }

  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.03,
          horizontal: screenWidth * 0.05,
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                onSaved: (value) => userName = _normalizeSpaces(value!),
                hint: AppStrings.name,
                suffix: const Icon(Icons.person),
                validator: FormValidators.validateName,
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                onSaved: (value) => email = value!,
                hint: AppStrings.email,
                suffix: const Icon(Icons.email),
                validator: FormValidators.validateEmail,
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                hint: AppStrings.phone,
                suffix: const Icon(Icons.phone),
                validator: FormValidators.validatePhone,
                onSaved: (value) => phoneNumber = value!,
              ),
              SizedBox(height: screenHeight * 0.02),
              const PasswordField(
                hintText: AppStrings.password,
                validator: FormValidators.validatePassword,
              ),
              SizedBox(height: screenHeight * 0.02),
              PasswordField(
                hintText: AppStrings.confirmPassword,
                validator: (value) =>
                    FormValidators.validateConfirmPassword(value, password),
              ),
              SizedBox(height: screenHeight * 0.02),
              //     const LocationDropdown(),
              SizedBox(height: screenHeight * 0.03),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCheckBox(
                    initialValue: isAgreed,
                    onChanged: (value) {
                      setState(() {
                        isAgreed = value;
                      });
                    },
                  ),
                  const TermsAndConditons(),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              CustomButton(
                onPressed: () {
                  //    Prefs.setBool(KIsloginSuccess, true);
                },
                text: AppStrings.register,
              ),
              SizedBox(height: screenHeight * 0.011),
              const HavaAnAccount(),
            ],
          ),
        ),
      ),
    );
  }
}
