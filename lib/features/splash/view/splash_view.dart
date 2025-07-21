import 'package:flutter/material.dart';
import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/features/Home/presentation/view/home_view.dart';
import 'package:beautilly/features/auth/presentation/view/signin_view.dart';
import 'package:beautilly/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const String routeName = '/';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // إعداد الانيميشن
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // بدء الانيميشن
    _controller.forward();

    // التحقق من حالة تسجيل الدخول بعد انتهاء الانيميشن
    Future.delayed(const Duration(seconds: 3), () {
      _checkAppState();
    });
  }

  Future<void> _checkAppState() async {
    if (!mounted) return;

    final cacheService = context.read<CacheService>();

    // التحقق من حالة التطبيق
    final isFirstTime = await cacheService.getIsFirstTime();
    final token = await cacheService.getToken();

    if (!mounted) return;

    if (isFirstTime) {
      // أول مرة يفتح التطبيق - عرض شاشة الـ onboarding
      Navigator.pushReplacementNamed(context, OnboardingView.routeName);
    } else if (token != null) {
      // مسجل دخول - الذهاب للرئيسية
      Navigator.pushReplacementNamed(context, HomeView.routeName);
    } else {
      // غير مسجل - الذهاب لتسجيل الدخول
      Navigator.pushReplacementNamed(context, SigninView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // يمكنك إضافة شعار التطبيق هنا
              Image.asset(
                'assets/images/logo.png', // تأكد من وجود الصورة
                width: 150,
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
