abstract class AcceptOfferState {}

class AcceptOfferInitial extends AcceptOfferState {}

class AcceptOfferLoading extends AcceptOfferState {}

class AcceptOfferSuccess extends AcceptOfferState {}

class AcceptOfferError extends AcceptOfferState {
  final String message;
  AcceptOfferError(this.message);
} 