// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hyper_market/core/services/shared_preferences.dart';
// import 'package:hyper_market/core/utils/common/cusom_progress_hud.dart';
// import 'package:hyper_market/core/utils/constants/colors.dart';
// import 'package:hyper_market/core/utils/constants/constants.dart';
// import 'package:hyper_market/core/utils/helper/error_message_helper.dart';
// import 'package:hyper_market/feature/auth/presentation/controller/signin/signin_cubit.dart';
// import 'package:hyper_market/feature/auth/presentation/view/widgets/signin_view_body.dart';
// import 'package:hyper_market/feature/home/presentation/view/home_view.dart';

// class SiginViewBodyBlocConsmer extends StatelessWidget {

//   const SiginViewBodyBlocConsmer({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<SignInCubit, SignInState>(
//       listener: (context, state) {
//         if (state is SignInSuccessState) {
//           Prefs.setBool(KIsloginSuccess, true);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('تم تسجيل الدخول بنجاح'),
//               backgroundColor: TColors.primary,
//               duration: Duration(seconds: 3),
//             ),
//           );
//           Navigator.pushNamedAndRemoveUntil(
//               context, HomeView.routeName, (route) => false);
//         } else if (state is SignInErrorState) {
//           showErrorSnackBar(context, state.message);
//         }
//       },
//       builder: (context, state) {
//         return CustomProgressHud( 
//           inLoading: state is SignInLoadingState ? true : false,
//          child: const SigninViewBody()  );
//       },
//     );
//   }
// }
