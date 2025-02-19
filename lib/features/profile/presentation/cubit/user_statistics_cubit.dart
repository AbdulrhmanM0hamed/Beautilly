import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_statistics.dart';
import '../../domain/repositories/user_statistics_repository.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/presentation/cubit/orders_state.dart';
import '../cubit/favorites_cubit/favorites_cubit.dart';
import '../cubit/favorites_cubit/favorites_state.dart';
import '../../../reservations/presentation/cubit/reservations_cubit.dart';
import '../../../reservations/presentation/cubit/reservations_state.dart';

part 'user_statistics_state.dart';

class UserStatisticsCubit extends Cubit<UserStatisticsState> {
  final UserStatisticsRepository repository;
  final FavoritesCubit favoritesCubit;
  final ReservationsCubit reservationsCubit;
  final OrdersCubit ordersCubit;
  
  late final StreamSubscription<FavoritesState> _favoritesSubscription;
  late final StreamSubscription<ReservationsState> _reservationsSubscription;
  late final StreamSubscription<OrdersState> _ordersSubscription;

  UserStatisticsCubit({
    required this.repository,
    required this.favoritesCubit,
    required this.reservationsCubit,
    required this.ordersCubit,
  }) : super(UserStatisticsInitial()) {
    // الاستماع لتغييرات المفضلة
    _favoritesSubscription = favoritesCubit.stream.listen((state) {
      if (state is FavoritesLoaded || state is FavoritesError) {
        loadUserStatistics();
      }
    });

    // الاستماع لتغييرات الحجوزات
    _reservationsSubscription = reservationsCubit.stream.listen((state) {
      if (state is ReservationsSuccess || state is ReservationsError) {
        loadUserStatistics();
      }
    });

    // الاستماع لتغييرات الطلبات
    _ordersSubscription = ordersCubit.stream.listen((state) {
      if (state is MyOrdersSuccess || state is OrdersError) {
        loadUserStatistics();
      }
    });
  }

  Future<void> loadUserStatistics() async {
    if (isClosed) return;
    
    emit(UserStatisticsLoading());
    final result = await repository.getUserStatistics();
    
    if (!isClosed) {
      result.fold(
        (failure) => emit(UserStatisticsError(failure.message)),
        (statistics) => emit(UserStatisticsLoaded(statistics)),
      );
    }
  }

  @override
  Future<void> close() {
    _favoritesSubscription.cancel();
    _reservationsSubscription.cancel();
    _ordersSubscription.cancel();
    return super.close();
  }
}