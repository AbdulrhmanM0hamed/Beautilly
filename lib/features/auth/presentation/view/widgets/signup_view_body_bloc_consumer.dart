
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hyper_market/core/utils/helper/error_message_helper.dart';
// import 'package:hyper_market/feature/auth/presentation/controller/signup/signup_cubit.dart';
// import 'package:hyper_market/feature/auth/presentation/view/signin_view.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'signup_view_body.dart';

// class SignUpViewBodyBlocConsumer extends StatelessWidget {
//   const SignUpViewBodyBlocConsumer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<SignUpCubit, SignUpState>(
//       listener: (context, state) {
//         if (state is SignUpSuccessState) {
//           Navigator.pushNamedAndRemoveUntil(
//               context, SigninView.routeName, (route) => false);
//           showSuccessSnackBar(
//             context,
//             'تم إنشاء الحساب بنجاح',
//           );
//         }
//         if (state is SignUpErrorState) {
//           showErrorSnackBar(context, state.message);
//         }
//       },
//       builder: (context, state) {
//         return ModalProgressHUD(
//             inAsyncCall: state is SignUpLoadingState ? true : false,
//             child: const SignupViewBody());
//       },
//     );
//   }
// }
