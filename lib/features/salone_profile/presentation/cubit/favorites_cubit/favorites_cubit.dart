import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_to_favorites_usecase.dart';
import '../../../domain/usecases/remove_from_favorites_usecase.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final AddToFavoritesUseCase addToFavoritesUseCase;
  final RemoveFromFavoritesUseCase removeFromFavoritesUseCase;

  FavoritesCubit({
    required this.addToFavoritesUseCase,
    required this.removeFromFavoritesUseCase,
  }) : super(FavoritesInitial());

  Future<void> toggleFavorite(int shopId, bool currentState) async {
    emit(FavoritesLoading());

    final result = currentState
        ? await removeFromFavoritesUseCase(shopId)
        : await addToFavoritesUseCase(shopId);

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) => emit(FavoritesSuccess(!currentState)),
    );
  }
} 