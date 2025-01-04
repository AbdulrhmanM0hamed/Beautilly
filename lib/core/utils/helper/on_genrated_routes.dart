import 'package:beautilly/features/auth/presentation/view/signin_view.dart';
import 'package:beautilly/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:beautilly/features/splash/view/splash_view.dart';
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
    default:
      return MaterialPageRoute(
        builder: (context) => const SplashView(),
      );
  }
}
