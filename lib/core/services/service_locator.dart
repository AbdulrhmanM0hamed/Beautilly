import 'package:beautilly/core/error/exceptions.dart';
import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:beautilly/core/services/network/network_info.dart';
import 'package:beautilly/core/services/notification/notification_service.dart';
import 'package:beautilly/features/Home/data/datasources/discounts_remote_data_source.dart';
import 'package:beautilly/features/Home/data/datasources/premium_shops_remote_data_source.dart';
import 'package:beautilly/features/Home/data/datasources/search_remote_data_source.dart';
import 'package:beautilly/features/Home/data/datasources/services_remote_datasource.dart';
import 'package:beautilly/features/Home/data/repositories/premium_shops_repository_impl.dart';
import 'package:beautilly/features/Home/data/repositories/search_repository_impl.dart';
import 'package:beautilly/features/Home/data/repositories/services_repository_impl.dart';
import 'package:beautilly/features/Home/domain/repositories/premium_shops_repository.dart';
import 'package:beautilly/features/Home/domain/repositories/search_repository.dart';
import 'package:beautilly/features/Home/domain/repositories/services_repository.dart';
import 'package:beautilly/features/Home/domain/usecases/get_premium_shops_usecase.dart';
import 'package:beautilly/features/Home/domain/usecases/get_services_usecase.dart';
import 'package:beautilly/features/Home/presentation/cubit/premium_shops_cubit/premium_shops_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/search_cubit/search_cubit.dart';
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
import 'package:beautilly/features/profile/data/datasources/user_statistics_remote_datasource.dart';
import 'package:beautilly/features/profile/data/repositories/user_statistics_repository_impl.dart';
import 'package:beautilly/features/profile/domain/repositories/user_statistics_repository.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:beautilly/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:beautilly/features/orders/domain/repositories/orders_repository.dart';
import 'package:beautilly/features/orders/domain/usecases/get_my_orders.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:beautilly/features/profile/presentation/cubit/user_statistics_cubit.dart';
import 'package:beautilly/features/salone_profile/data/datasources/salon_profile_remote_data_source.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/favorites_cubit/toggle_favorites_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
import '../../features/booking/data/datasources/booking_remote_datasource.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/presentation/cubit/booking_cubit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:beautilly/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:beautilly/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:beautilly/features/notifications/domain/usecases/get_notifications.dart';
import 'package:beautilly/features/notifications/presentation/cubit/notifications_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core Services
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<CacheService>(() => CacheServiceImpl(sl()));
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(Connectivity()));
  sl.registerLazySingleton(() => SharedPreferencesService(sharedPreferences));
  sl.registerLazySingleton(() => GlobalKey<NavigatorState>());

  //! Auth Feature
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl(), sl<NetworkInfo>()),
  );

  // Cubits
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl()));
  sl.registerFactory<LocationCubit>(
      () => LocationCubit(sl<LocationRepository>()));
  sl.registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(sl()));

//--------------------------------------------------------------------

  //! Profile Feature
  // Data Sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
      authRepository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Cubits
  sl.registerFactory(() => ProfileCubit(repository: sl()));
  sl.registerFactory(() => ProfileImageCubit(repository: sl()));

//--------------------------------------------------------------------

  //! User Statistics Feature
  // Data Sources
  sl.registerFactory<UserStatisticsRemoteDataSource>(
    () => UserStatisticsRemoteDataSourceImpl(
      authRepository: sl(),
      client: sl(),
      cacheService: sl(),
    ),
  );

  // Repositories
  sl.registerFactory<UserStatisticsRepository>(
    () => UserStatisticsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Cubits
  sl.registerFactory<UserStatisticsCubit>(
    () => UserStatisticsCubit(
      repository: sl(),
      favoritesCubit: sl(),
      reservationsCubit: sl(),
      ordersCubit: sl(),
    ),
  );

//--------------------------------------------------------------------

  //! Favorites Feature
  // Data Sources
  sl.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
      authRepository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddToFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromFavoritesUseCase(sl()));

  // Cubits
  sl.registerLazySingleton<FavoritesCubit>(
    () => FavoritesCubit(
      repository: sl(),
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

//--------------------------------------------------------------------

  //! Orders Feature
  // Data Sources
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(
      authRepository: sl(),
      client: sl(),
      cacheService: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetMyOrders(sl()));
  sl.registerLazySingleton(() => GetAllOrders(sl()));
  sl.registerLazySingleton(() => DeleteOrderUseCase(sl()));
  sl.registerLazySingleton(() => AcceptOfferUseCase(sl()));
  sl.registerLazySingleton(() => CancelOfferUseCase(sl()));

  // Cubits
  sl.registerFactory(() => OrdersCubit(getMyOrders: sl(), getAllOrders: sl()));
  sl.registerFactory(() => AddOrderCubit(addOrderUseCase: sl()));
  sl.registerFactory(() => DeleteOrderCubit(deleteOrderUseCase: sl()));
  sl.registerFactory(() => AcceptOfferCubit(acceptOfferUseCase: sl()));
  sl.registerFactory(() => OrderDetailsCubit(sl()));
  sl.registerFactory(() => CancelOfferCubit(cancelOfferUseCase: sl()));

//--------------------------------------------------------------------

  //! Reservations Feature
  // Data Sources
  sl.registerLazySingleton<ReservationsRemoteDataSource>(
    () => ReservationsRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
      authRepository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<ReservationsRepository>(
    () => ReservationsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetMyReservations(sl()));

  // Cubits
  sl.registerFactory(() => ReservationsCubit(getMyReservationsUseCase: sl()));

  //! Services Feature
  // Data Sources
  sl.registerLazySingleton<ServicesRemoteDataSource>(
    () => ServicesRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
      authRepository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<ServicesRepository>(
    () => ServicesRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetServices(sl()));

  // Cubits
  sl.registerFactory(() => ServicesCubit(repository: sl<ServicesRepository>()));

//--------------------------------------------------------------------

  //! Premium Shops Feature
  // Data Sources
  sl.registerLazySingleton<PremiumShopsRemoteDataSource>(
    () => PremiumShopsRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
      authRepository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<PremiumShopsRepository>(
    () => PremiumShopsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetPremiumShopsUseCase(sl()));

  // Cubits
  sl.registerFactory(() => PremiumShopsCubit(getPremiumShopsUseCase: sl()));

//--------------------------------------------------------------------

  //! Discounts Feature
  // Data Sources
  sl.registerLazySingleton<DiscountsRemoteDataSource>(
    () => DiscountsRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
      authRepository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<DiscountsRepository>(
    () => DiscountsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDiscountsUseCase(sl()));

  // Cubits
  sl.registerFactory(() => DiscountsCubit(repository: sl()));

//--------------------------------------------------------------------

  //! Salon Profile Feature
  // Data Sources
  sl.registerLazySingleton<SalonProfileRemoteDataSource>(
    () => SalonProfileRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
      authRepository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<SalonProfileRepository>(
    () => SalonProfileRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(
      () => GetSalonProfileUseCase(sl<SalonProfileRepository>()));
  sl.registerLazySingleton(() => AddShopRatingUseCase(sl()));
  sl.registerLazySingleton(() => DeleteShopRatingUseCase(sl()));

  // Cubits
  sl.registerFactory<SalonProfileCubit>(
    () =>
        SalonProfileCubit(getSalonProfileUseCase: sl<GetSalonProfileUseCase>()),
  );

  sl.registerFactory(() => RatingCubit(
        addShopRatingUseCase: sl(),
        deleteShopRatingUseCase: sl(),
      ));

//--------------------------------------------------------------------

  //! Booking Feature
  // Data Sources
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Cubits
  sl.registerFactory(() => BookingCubit(repository: sl()));

//--------------------------------------------------------------------

  //! Search Feature
  // Data Sources
  sl.registerLazySingleton<SearchShopsRemoteDataSource>(
    () => SearchShopsRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<SearchShopsRepository>(
    () => SearchShopsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Cubits
  sl.registerFactory(() => SearchShopsCubit(repository: sl()));

//--------------------------------------------------------------------

  // Search
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerFactory(
    () => SearchCubit(searchRepository: sl()),
  );

  //! Statistics Feature
  // Repositories
  sl.registerFactory<StatisticsRepository>(
    () => StatisticsRepositoryImpl(
      authRepository: sl(),
      networkInfo: sl(),
      cacheService: sl(),
      client: sl(),
    ),
  );

  // Cubits
  sl.registerFactory<StatisticsCubit>(
    () => StatisticsCubit(sl<StatisticsRepository>()),
  );

//--------------------------------------------------------------------

  //! Location Feature
  // Repositories
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      client: sl(),
      networkInfo: sl(),
    ),
  );

  // Notification Service
  sl.registerLazySingleton(() => NotificationService(
        authRepository: sl(),
        cacheService: sl(),
        navigatorKey: sl(),
        database: FirebaseDatabase.instance,
      ));

  // Notifications Feature
  // Data sources
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(
      client: sl(),
      cacheService: sl(),
      authRepository: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => NotificationsCubit(
      getNotifications: sl(),
      repository: sl(),
    ),
  );
}

//--------------------------------------------------------------------

mixin TokenRefreshMixin {
  Future<T> withTokenRefresh<T>({
    required Future<T> Function(String token) request,
    required AuthRepository authRepository,
    required CacheService cacheService,
  }) async {
    try {
      final token = await cacheService.getToken();
      if (token == null) {
        throw UnauthorizedException('يرجى تسجيل الدخول أولاً');
      }

      try {
        return await request(token);
      } on UnauthorizedException {
        // محاولة تجديد الـ token
        final refreshResult = await authRepository.refreshToken();
        return refreshResult.fold(
          (failure) => throw UnauthorizedException('يرجى إعادة تسجيل الدخول'),
          (newToken) => request(newToken),
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
