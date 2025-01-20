import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/core/utils/common/custom_text_field.dart';
import 'package:beautilly/core/utils/common/location_dropdown.dart';
import 'package:beautilly/core/utils/common/password_field.dart';
import 'package:beautilly/core/utils/constant/app_strings.dart';
import 'package:beautilly/core/utils/validators/form_validators.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/custom_check_box.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/hava_an_account.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/terms_and_condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auth_cubit.dart';
import 'package:beautilly/features/auth/presentation/cubit/location_cubit.dart';
import 'package:beautilly/features/auth/presentation/view/widgets/signup_view_body_bloc_consumer.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  late String email, userName, phoneNumber;
  String password = ''; 
  bool isAgreed = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _normalizeSpaces(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  void _handleRegister() {
    if (!isAgreed) {
      CustomSnackbar.showError(
        context: context,
        message: 'يجب الموافقة على الشروط والأحكام',
      );
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      
      password = _passwordController.text;

      final locationState = context.read<LocationCubit>().state;
      if (locationState.selectedState == null || locationState.selectedCity == null) {
        CustomSnackbar.showError(
          context: context,
          message: 'الرجاء اختيار المنطقة والمدينة',
        );
        return;
      }

      final userData = {
        'name': userName.trim(),
        'email': email.trim(),
        'password': password,
        'password_confirmation': password,
        'phone': phoneNumber,
        'state_id': locationState.selectedState!.id,
        'city_id': locationState.selectedCity!.id,
      };

      context.read<AuthCubit>().register(userData);
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.03,
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    onSaved: (value) => userName = _normalizeSpaces(value!),
                    label: AppStrings.name,
                    suffix: const Icon(Icons.person),
                    validator: FormValidators.validateName,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  CustomTextField(
                    onSaved: (value) => email = value!,
                    label: AppStrings.email,
                    suffix: const Icon(Icons.email),
                    validator: FormValidators.validateEmail,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  CustomTextField(
                    label: AppStrings.phone,
                    suffix: const Icon(Icons.phone),
                    validator: FormValidators.validatePhone,
                    onSaved: (value) => phoneNumber = value!,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  PasswordField(
                    controller: _passwordController,
                    hintText: AppStrings.password,
                    validator: FormValidators.validatePassword,
                    onSaved: (value) => password = value ?? '',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  PasswordField(
                    controller: _confirmPasswordController,
                    hintText: AppStrings.confirmPassword,
                    validator: (value) =>
                        FormValidators.validateConfirmPassword(value, _passwordController.text),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  const LocationDropdown(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  CustomButton(
                    onPressed: _handleRegister,
                    text: AppStrings.register,
                  ),
                  const SizedBox(height: 11),
                  const HavaAnAccount(),
                ],
              ),
            ),
          ),
        ),
        const SignupViewBodyBlocConsumer(),
      ],
    );
  }
}
