// import 'package:beautilly/core/utils/common/custom_app_bar.dart';
// import 'package:beautilly/core/utils/common/custom_button.dart';
// import 'package:beautilly/core/utils/common/custom_text_field.dart';
// import 'package:beautilly/core/utils/constant/app_strings.dart';

// import 'package:beautilly/core/utils/validators/form_validators.dart';
// import 'package:flutter/material.dart';

// class NewPasswordView extends StatelessWidget {
//   static const String routeName = 'NewPasswordView';
//   final String token;
//   final String email;

//   NewPasswordView({
//     super.key,
//     required this.token,
//     required this.email,
//   });

//   final formKey = GlobalKey<FormState>();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: AppStrings.resetPassword,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: formKey,
//           child: Column(
//             children: [
//               CustomTextField(
//                 validator: FormValidators.validatePassword,
//                 hint: AppStrings.newPassword,
//                 onSaved: (value) => passwordController.text = value!,
//               ),
//               const SizedBox(height: 16),
//               CustomTextField(
//                 validator: (value) => FormValidators.validateConfirmPassword(
//                     value, passwordController.text),
//                 hint: AppStrings.newPasswordConfirmation,
//                 onSaved: (value) => confirmPasswordController.text = value!,
//               ),
//               const SizedBox(height: 24),
//               CustomButton(
//                 text: AppStrings.updatePassword,
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
