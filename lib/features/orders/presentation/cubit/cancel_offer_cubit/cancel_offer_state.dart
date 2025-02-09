
abstract class CancelOfferState {}

class CancelOfferInitial extends CancelOfferState {}

class CancelOfferLoading extends CancelOfferState {}

class CancelOfferSuccess extends CancelOfferState {
  final int offerId;

  CancelOfferSuccess({required this.offerId});
}


class CancelOfferError extends CancelOfferState {
  final String message;

  CancelOfferError(this.message);
} 