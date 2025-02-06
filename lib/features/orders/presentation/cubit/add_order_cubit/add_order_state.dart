import 'package:equatable/equatable.dart';

abstract class AddOrderState extends Equatable {
  const AddOrderState();

  @override
  List<Object?> get props => [];
}

class AddOrderInitial extends AddOrderState {}

class AddOrderLoading extends AddOrderState {}

class AddOrderSuccess extends AddOrderState {
  final Map<String, dynamic> data;

  const AddOrderSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class AddOrderError extends AddOrderState {
  final String message;

  const AddOrderError(this.message);

  @override
  List<Object?> get props => [message];
} 