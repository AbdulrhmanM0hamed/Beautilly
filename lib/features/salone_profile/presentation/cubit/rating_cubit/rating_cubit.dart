import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_shop_rating_usecase.dart';
import 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final AddShopRatingUseCase addShopRatingUseCase;

  RatingCubit({required this.addShopRatingUseCase}) : super(RatingInitial());

  Future<void> addRating({
    required int shopId,
    required int rating,
    String? comment,
  }) async {
    emit(RatingLoading());

    final result = await addShopRatingUseCase(
      shopId: shopId,
      rating: rating,
      comment: comment,
    );

    result.fold(
      (failure) => emit(RatingError(failure.message)),
      (_) => emit(RatingSuccess(rating: rating, comment: comment)),
    );
  }
} 