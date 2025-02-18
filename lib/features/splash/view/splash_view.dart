import 'package:flutter/material.dart';
import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/features/Home/presentation/view/home_view.dart';
import 'package:beautilly/features/auth/presentation/view/signin_view.dart';
import 'package:provider/provider.dart';

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
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    final cacheService = context.read<CacheService>();
    final token = await cacheService.getToken();

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        token != null ? HomeView.routeName : SigninView.routeName,
      );
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
