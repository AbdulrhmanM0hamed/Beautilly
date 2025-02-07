abstract class DeleteOrderState {}

class DeleteOrderInitial extends DeleteOrderState {}

class DeleteOrderLoading extends DeleteOrderState {}

class DeleteOrderSuccess extends DeleteOrderState {}

class DeleteOrderError extends DeleteOrderState {
  final String message;
  DeleteOrderError(this.message);
} 