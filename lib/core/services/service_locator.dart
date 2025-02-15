import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/features/Home/data/datasources/discounts_remote_data_source.dart';
import 'package:beautilly/features/Home/data/datasources/premium_shops_remote_data_source.dart';
import 'package:beautilly/features/Home/data/datasources/services_remote_datasource.dart';
import 'package:beautilly/features/Home/data/repositories/premium_shops_repository_impl.dart';
import 'package:beautilly/features/Home/data/repositories/services_repository_impl.dart';
import 'package:beautilly/features/Home/domain/repositories/premium_shops_repository.dart';
import 'package:beautilly/features/Home/domain/repositories/services_repository.dart';
import 'package:beautilly/features/Home/domain/usecases/get_premium_shops_usecase.dart';
import 'package:beautilly/features/Home/domain/usecases/get_services_usecase.dart';
import 'package:beautilly/features/Home/presentation/cubit/premium_shops_cubit/premium_shops_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/service_cubit/services_cubit.dart';
import 'package:beautilly/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:beautilly/features/nearby/data/datasources/search_shops_remote_datasource.dart';
import 'package:beautilly/features/nearby/data/repositories/search_shops_repository_impl.dart';
import 'package:beautilly/features/nearby/domain/repositories/search_shops_repository.dart';
import 'package:beautilly/features/nearby/presentation/cubit/search_shops_cubit.dart';
import 'package:beautilly/features/orders/domain/usecases/accept_offer_usecase.dart';
import 'package:beautilly/features/orders/domain/usecases/add_order_usecase.dart';
import 'package:beautilly/features/orders/domain/usecases/delete_order_usecase.dart';
import 'package:beautilly/features/orders/presentation/cubit/accept_offer_cubit/accept_offer_cubit.dart';
import 'package:beautilly/features/orders/presentation/cubit/add_order_cubit/add_order_cubit.dart';
import 'package:beautilly/features/orders/presentation/cubit/delete_order_cubit/delete_order_cubit.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:beautilly/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:beautilly/features/orders/domain/repositories/orders_repository.dart';
import 'package:beautilly/features/orders/domain/usecases/get_my_orders.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:beautilly/features/salone_profile/data/datasources/salon_profile_remote_data_source.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/favorites_cubit/toggle_favorites_cubit.dart';
import 'package:get_it/get_it.dart';
import '../../features/Home/data/repositories/statistics_repository_impl.dart';
import '../../features/Home/domain/repositories/statistics_repository.dart';
import '../../features/Home/presentation/cubit/statistics_cubit/statistics_cubit.dart';
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
import '../../features/profile/presentation/cubit/profile_image_cubit/profile_image_cubit.dart';
import '../../features/profile/presentation/cubit/favorites_cubit/favorites_cubit.dart';
import '../../features/profile/data/datasources/favorites_remote_datasource.dart';
import '../../features/profile/data/repositories/favorites_repository_impl.dart';
import '../../features/profile/domain/repositories/favorites_repository.dart';
import '../../features/Home/data/repositories/discounts_repository_impl.dart';
import '../../features/Home/domain/repositories/discounts_repository.dart';
import '../../features/Home/domain/usecases/get_discounts_usecase.dart';
import '../../features/Home/presentation/cubit/discounts_cubit/discounts_cubit.dart';
import '../../features/orders/presentation/cubit/order_details_cubit/order_details_cubit.dart';
import 'package:beautilly/features/orders/presentation/cubit/cancel_offer_cubit/cancel_offer_cubit.dart';
import 'package:beautilly/features/orders/domain/usecases/cancel_offer_usecase.dart';
import '../../features/salone_profile/presentation/cubit/salon_profile_cubit/salon_profile_cubit.dart';
import '../../features/salone_profile/domain/usecases/get_salon_profile.dart';
import '../../features/salone_profile/data/repositories/salon_profile_repository_impl.dart';
import '../../features/salone_profile/domain/repositories/salon_profile_repository.dart';
import '../../features/salone_profile/presentation/cubit/rating_cubit/rating_cubit.dart';
import '../../features/salone_profile/domain/usecases/add_shop_rating_usecase.dart';
import '../../features/salone_profile/domain/usecases/delete_shop_rating_usecase.dart';
import '../../features/salone_profile/domain/usecases/add_to_favorites_usecase.dart';
import '../../features/salone_profile/domain/usecases/remove_from_favorites_usecase.dart';

import '../../features/Home/presentation/cubit/service_shops_cubit/service_shops_cubit.dart';
import '../../features/booking/data/datasources/booking_remote_datasource.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/presentation/cubit/booking_cubit.dart';

// Tailoring Requests Feature

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<CacheService>(() => CacheServiceImpl(sl()));
  sl.registerLazySingleton(() => http.Client());

  // Auth Feature
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
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
    () => OrdersRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => AddOrderUseCase(sl()));
  sl.registerFactory(() => AddOrderCubit(addOrderUseCase: sl()));

  sl.registerLazySingleton(() => GetMyOrders(sl()));

  sl.registerLazySingleton(() => GetAllOrders(sl()));

  sl.registerFactory(
    () => OrdersCubit(
      getMyOrders: sl(),
      getAllOrders: sl(),
    ),
  );

  // Reservations Feature
  sl.registerLazySingleton<ReservationsRemoteDataSource>(
    () => ReservationsRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton<ReservationsRepository>(
    () => ReservationsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetMyReservations(sl()));

  sl.registerFactory(
    () => ReservationsCubit(
      getMyReservationsUseCase: sl(),
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

  // Favorites Feature
  // 1. تسجيل DataSource
  sl.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );

  // 2. تسجيل Repository
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl()),
  );

  // sl.registerLazySingleton<FavoritesCubit>(
  //   () => FavoritesCubit(
  //     repository: sl(),
  //     addToFavoritesUseCase: sl<AddToFavoritesUseCase>(),
  //     removeFromFavoritesUseCase: sl<RemoveFromFavoritesUseCase>(),
  //   ),
  // );

  sl.registerLazySingleton(() => AddToFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromFavoritesUseCase(sl()));

  // services Feature
  sl.registerLazySingleton<ServicesRemoteDataSource>(
    () => ServicesRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );

  sl.registerLazySingleton<ServicesRepository>(
    () => ServicesRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => GetServices(sl()),
  );

  sl.registerFactory(
    () => ServicesCubit(sl<ServicesRepository>()),
  );

  // Premium Shops Feature
  sl.registerLazySingleton<PremiumShopsRemoteDataSource>(
    () => PremiumShopsRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );

  sl.registerLazySingleton<PremiumShopsRepository>(
    () => PremiumShopsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => GetPremiumShopsUseCase(sl()),
  );

  sl.registerFactory(
    () => PremiumShopsCubit(getPremiumShopsUseCase: sl()),
  );

  // Discounts Feature
  sl.registerLazySingleton<DiscountsRemoteDataSource>(
    () => DiscountsRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );

  sl.registerLazySingleton<DiscountsRepository>(
    () => DiscountsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => GetDiscountsUseCase(sl()),
  );

  sl.registerFactory(
    () => DiscountsCubit(getDiscountsUseCase: sl()),
  );

  // Orders Feature
  sl.registerFactory(
    () => DeleteOrderCubit(deleteOrderUseCase: sl()),
  );

  sl.registerLazySingleton(
    () => DeleteOrderUseCase(sl()),
  );

  // Accept Offer Feature
  sl.registerLazySingleton(() => AcceptOfferUseCase(sl()));
  sl.registerFactory(() => AcceptOfferCubit(acceptOfferUseCase: sl()));

  // Repository

  // Data sources

  // Cubits
  sl.registerFactory(() => OrderDetailsCubit(sl()));

  // Orders Feature
  sl.registerLazySingleton(() => CancelOfferUseCase(sl()));
  sl.registerFactory(() => CancelOfferCubit(
        cancelOfferUseCase: sl(),
      ));

  // Salon Profile Feature
  sl.registerLazySingleton<SalonProfileRepository>(
    () => SalonProfileRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<SalonProfileRemoteDataSource>(
    () => SalonProfileRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetSalonProfileUseCase(sl<SalonProfileRepository>()),
  );

  sl.registerFactory<SalonProfileCubit>(
    () => SalonProfileCubit(
      getSalonProfileUseCase: sl<GetSalonProfileUseCase>(),
    ),
  );

  // تسجيل FavoritesCubit
  sl.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(
      repository: sl<FavoritesRepository>(),
      addToFavoritesUseCase: sl<AddToFavoritesUseCase>(),
      removeFromFavoritesUseCase: sl<RemoveFromFavoritesUseCase>(),
    ),
  );
  sl.registerFactory<ToggleFavoritesCubit>(
    () => ToggleFavoritesCubit(
      addToFavoritesUseCase: sl<AddToFavoritesUseCase>(),
      removeFromFavoritesUseCase: sl<RemoveFromFavoritesUseCase>(),
    ),
  );

  // Rating Feature
  sl.registerFactory(
    () => RatingCubit(
      addShopRatingUseCase: sl(),
      deleteShopRatingUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => AddShopRatingUseCase(sl()),
  );

  sl.registerLazySingleton(
    () => DeleteShopRatingUseCase(sl()),
  );

  // Service Shops Feature
  sl.registerFactory(
    () => ServiceShopsCubit(
      getServices: sl(),
    ),
  );

  // Booking Feature
  // Cubit
  sl.registerFactory(() => BookingCubit(
        repository: sl(),
      ));

  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );

  // Cubits
  sl.registerFactory(() => SearchShopsCubit(repository: sl()));

  // Repositories
  sl.registerLazySingleton<SearchShopsRepository>(
    () => SearchShopsRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<SearchShopsRemoteDataSource>(
    () => SearchShopsRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );
}
