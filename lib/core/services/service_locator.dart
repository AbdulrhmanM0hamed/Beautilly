import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:beautilly/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:beautilly/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:beautilly/features/orders/domain/repositories/orders_repository.dart';
import 'package:beautilly/features/orders/domain/usecases/get_my_orders.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_cubit.dart';
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
import 'package:http/http.dart' as http;
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/orders/domain/usecases/get_all_orders.dart';
import '../../features/reservations/data/datasources/reservations_remote_datasource.dart';
import '../../features/reservations/data/repositories/reservations_repository_impl.dart';
import '../../features/reservations/domain/repositories/reservations_repository.dart';
import '../../features/reservations/domain/usecases/get_my_reservations.dart';
import '../../features/reservations/presentation/cubit/reservations_cubit.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_image_cubit.dart';

// Tailoring Requests Feature

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<CacheService>(() => CacheServiceImpl(sl()));
  sl.registerLazySingleton(() => http.Client());

  // Auth Feature
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl()));

  // Tailoring Requests Feature
  // Data Sources

  // Repositories

  // Use Cases

  // Cubits

  // Services
  sl.registerLazySingleton(() => SharedPreferencesService(sharedPreferences));

  // Repositories
  sl.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(),
  );

  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(),
  );

  // Cubits
  sl.registerFactory(
    () => StatisticsCubit(sl<StatisticsRepository>()),
  );

  sl.registerFactory<LocationCubit>(
    () => LocationCubit(sl<LocationRepository>()),
  );

  sl.registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(sl()));

  // Home Feature
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );

  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetMyOrders(sl()));

  sl.registerLazySingleton(() => GetAllOrders(sl()));

  sl.registerFactory(
    () => OrdersCubit(
      getMyOrders: sl(),
      // getMyReservations: sl(),
      getAllOrders: sl(),
    ),
  );

  // Reservations Feature
  sl.registerLazySingleton<ReservationsRemoteDataSource>(
    () => ReservationsRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );

  sl.registerLazySingleton<ReservationsRepository>(
    () => ReservationsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetMyReservations(sl()));

  sl.registerFactory(
    () => ReservationsCubit(
      getMyReservations: sl(),
    ),
  );

  // Profile Feature
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => ProfileCubit(repository: sl()),
  );

  sl.registerFactory(
    () => ProfileImageCubit(
      sl<ProfileRepository>(),
      sl<ProfileCubit>(),
    ),
  );
}
