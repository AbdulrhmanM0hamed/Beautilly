import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/splash/view/splash_view.dart';
import 'package:beautilly/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/utils/helper/on_genrated_routes.dart';
import 'core/utils/theme/app_theme.dart';
import 'core/services/service_locator.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'core/services/cache/cache_service.dart';
import 'core/services/cache/cache_service_impl.dart';
import 'package:beautilly/core/services/notification/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('📱 Background message received: ${message.messageId}');
  await NotificationService.handleBackgroundMessage(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // تهيئة Firebase Database
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  if (kDebugMode) {
    FirebaseDatabase.instance.setLoggingEnabled(true);
  }

  // تسجيل معالج الإشعارات في الخلفية

  final prefs = await SharedPreferences.getInstance();
  await di.init();
  await di.sl<NotificationService>().init();

  runApp(
    MultiProvider(
      providers: [
        Provider<CacheService>(
          create: (_) => CacheServiceImpl(prefs),
        ),
      ],
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<ProfileCubit>()..loadProfile(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: di.sl<NotificationService>().navigatorKey,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        title: 'دلالاك',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        supportedLocales: const [
          Locale('ar'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        onGenerateRoute: onGenratedRoutes,
        initialRoute: SplashView.routeName,
      ),
    );
  }
}
