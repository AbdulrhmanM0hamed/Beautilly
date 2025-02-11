abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesSuccess extends FavoritesState {
  final bool isFavorite;
  FavoritesSuccess(this.isFavorite);
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
} 