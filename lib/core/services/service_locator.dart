import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:get_it/get_it.dart';
import '../../features/Home/data/repositories/statistics_repository_impl.dart';
import '../../features/Home/domain/repositories/statistics_repository.dart';
import '../../features/Home/presentation/cubit/statistics_cubit.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cache/shared_preferences_service.dart';
import 'cache/cache_service_impl.dart';
import '../../features/auth/presentation/cubit/location_cubit.dart';
import '../../features/auth/domain/repositories/location_repository.dart';
import '../../features/auth/data/repositories/location_repository_impl.dart';
import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt
      .registerLazySingleton(() => SharedPreferencesService(sharedPreferences));

  getIt.registerLazySingleton<CacheService>(
    () => CacheServiceImpl(sharedPreferences),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<CacheService>()),
  );

  getIt.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(),
  );

  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(),
  );

  // Cubits
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      getIt<AuthRepository>(),
      getIt<CacheService>(),
    ),
  );

  getIt.registerFactory(
    () => StatisticsCubit(getIt<StatisticsRepository>()),
  );

  getIt.registerFactory<LocationCubit>(
    () => LocationCubit(getIt<LocationRepository>()),
  );

  getIt.registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(getIt()));
}
