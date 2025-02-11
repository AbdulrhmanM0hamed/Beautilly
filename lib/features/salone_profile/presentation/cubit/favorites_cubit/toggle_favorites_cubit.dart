import 'package:beautilly/features/salone_profile/domain/usecases/add_to_favorites_usecase.dart';
import 'package:beautilly/features/salone_profile/domain/usecases/remove_from_favorites_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'toggle_favorites_state.dart';

class ToggleFavoritesCubit extends Cubit<ToggleFavoritesState> {
  final AddToFavoritesUseCase addToFavoritesUseCase;
  final RemoveFromFavoritesUseCase removeFromFavoritesUseCase;

  ToggleFavoritesCubit({
    required this.addToFavoritesUseCase,
    required this.removeFromFavoritesUseCase,
  }) : super(ToggleFavoritesInitial());

  Future<void> addToFavorites(int shopId) async {
    try {
      emit(ToggleFavoritesLoading());
      await addToFavoritesUseCase(shopId);
      emit(const ToggleFavoritesSuccess(isFavorite: true));
    } catch (e) {
      emit(ToggleFavoritesError(message: e.toString()));
    }
  }

  Future<void> removeFromFavorites(int shopId) async {
    try {
      emit(ToggleFavoritesLoading());
      await removeFromFavoritesUseCase(shopId);
      emit(const ToggleFavoritesSuccess(isFavorite: false));
    } catch (e) {
      emit(ToggleFavoritesError(message: e.toString()));
    }
  }
}
