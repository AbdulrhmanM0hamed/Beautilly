import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/Home/presentation/view/home_view.dart';
import 'package:beautilly/features/auth/presentation/view/forget_password.dart';
import 'package:beautilly/features/auth/presentation/view/signin_view.dart';
import 'package:beautilly/features/auth/presentation/view/signup_view.dart';
import 'package:beautilly/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:beautilly/features/orders/presentation/view/add_order_view.dart';
import 'package:beautilly/features/splash/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/orders/presentation/cubit/add_order_cubit/add_order_cubit.dart';

Route<dynamic> onGenratedRoutes(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(
        builder: (context) => const SplashView(),
      );
    case OnboardingView.routeName:
      return MaterialPageRoute(
        builder: (context) => const OnboardingView(),
      );
    case SigninView.routeName:
      return MaterialPageRoute(
        builder: (context) => const SigninView(),
      );
    case SignupView.routeName:
      return MaterialPageRoute(
        builder: (context) => const SignupView(),
      );
    case ForgotPasswordView.routeName:
      return MaterialPageRoute(
        builder: (_) => const ForgotPasswordView(),
      );
    // case NewPasswordView.routeName:
    //   final args = settings.arguments as Map<String, String>;
    //   return MaterialPageRoute(
    //     builder: (_) => NewPasswordView(
    //       token: args['token']!,
    //       email: args['email']!,
    //     ),
    //   );
    case HomeView.routeName:
      return MaterialPageRoute(builder: (context) => const HomeView());
    // case SalonProfileView.routeName:
    //   final args = settings.arguments as Map<String, dynamic>;
    //   return MaterialPageRoute(
    //     builder: (context) => SalonProfileView(
    //       salonId: args['salonId'] as int,
    //     ),
    //   );
    case AddOrderView.routeName:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => sl<AddOrderCubit>(),
          child: const AddOrderView(),
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const SplashView(),
      );
  }
}
