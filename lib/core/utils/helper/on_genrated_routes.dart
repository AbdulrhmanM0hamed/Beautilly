import 'package:beautilly/features/Home/presentation/view/home_view.dart';
import 'package:beautilly/features/auth/presentation/view/forget_password.dart';
import 'package:beautilly/features/auth/presentation/view/new_password_view.dart';
import 'package:beautilly/features/auth/presentation/view/signin_view.dart';
import 'package:beautilly/features/auth/presentation/view/signup_view.dart';
import 'package:beautilly/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:beautilly/features/splash/view/splash_view.dart';
import 'package:beautilly/features/salone_profile/presentation/view/salone_profile_view.dart';
import 'package:flutter/material.dart';

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
    case NewPasswordView.routeName:
      final args = settings.arguments as Map<String, String>;
      return MaterialPageRoute(
        builder: (_) => NewPasswordView(
          token: args['token']!,
          email: args['email']!,
        ),
      );
    case HomeView.routeName:
      return MaterialPageRoute(builder: (context) => const HomeView());
    case SalonProfileView.routeName:
      return MaterialPageRoute(
        builder: (context) => const SalonProfileView(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const SplashView(),
      );
  }
}
