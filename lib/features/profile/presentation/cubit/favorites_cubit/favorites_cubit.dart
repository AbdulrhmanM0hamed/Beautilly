import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/favorites_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repository;

  FavoritesCubit({required this.repository}) : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    
    final result = await repository.getFavoriteShops();
    
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  // Future<void> toggleFavorite(int shopId) async {
  //   final currentState = state;
  //   if (currentState is FavoritesLoaded) {
  //     try {
  //       final result = await repository.toggleFavorite(shopId);
        
  //       result.fold(
  //         (failure) => emit(FavoritesError(failure.message)),
  //         (_) {
  //           emit(const FavoriteToggleSuccess('تم تحديث المفضلة'));
  //           loadFavorites(); // إعادة تحميل القائمة
  //         },
  //       );
  //     } catch (e) {
  //       emit(FavoritesError(e.toString()));
  //     }
  //   }
  // }
} 