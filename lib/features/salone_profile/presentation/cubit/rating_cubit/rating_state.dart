abstract class RatingState {}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingSuccess extends RatingState {
  final int rating;
  final String? comment;

  RatingSuccess({required this.rating, this.comment});
}

class RatingError extends RatingState {
  final String message;

  RatingError(this.message);
} 