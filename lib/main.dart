import 'package:beautilly/core/services/cache/cache_service_impl.dart';
import 'package:beautilly/features/Home/presentation/view/home_view.dart';
import 'package:beautilly/features/auth/presentation/view/signin_view.dart';
import 'package:beautilly/features/auth/presentation/view/signup_view.dart';
import 'package:beautilly/features/orders/data/services/orders_service.dart';
import 'package:beautilly/features/splash/view/splash_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/utils/helper/on_genrated_routes.dart';
import 'core/utils/theme/app_theme.dart';

import 'core/services/service_locator.dart';
import 'core/services/cache/cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:beautilly/features/auth/domain/repositories/auth_repository.dart';
import 'package:beautilly/features/auth/data/repositories/auth_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  final sharedPreferences = await SharedPreferences.getInstance();
  final cacheService = CacheServiceImpl(sharedPreferences);

  runApp(
    MultiProvider(
      providers: [
        Provider<CacheService>(
          create: (_) => cacheService,
        ),
        ProxyProvider<CacheService, AuthRepository>(
          update: (context, cacheService, previous) => 
              AuthRepositoryImpl(cacheService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beautilly',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: onGenratedRoutes,
      initialRoute: SigninView.routeName,
    );
  }
}
