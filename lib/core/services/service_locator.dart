import 'package:get_it/get_it.dart';
import '../../features/Home/data/repositories/statistics_repository_impl.dart';
import '../../features/Home/domain/repositories/statistics_repository.dart';
import '../../features/Home/presentation/cubit/statistics_cubit.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cache/shared_preferences_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt
      .registerLazySingleton(() => SharedPreferencesService(sharedPreferences));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  getIt.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(),
  );

  // Cubits
  getIt.registerFactory(
    () => AuthCubit(getIt<AuthRepository>()),
  );

  getIt.registerFactory(
    () => StatisticsCubit(getIt<StatisticsRepository>()),
  );
}
