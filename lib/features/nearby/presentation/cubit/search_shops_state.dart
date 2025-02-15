import 'package:equatable/equatable.dart';
import '../../domain/entities/search_shop.dart';

abstract class SearchShopsState extends Equatable {
  const SearchShopsState();

  @override
  List<Object?> get props => [];
}

class SearchShopsInitial extends SearchShopsState {}

class SearchShopsLoading extends SearchShopsState {}

class SearchShopsLoaded extends SearchShopsState {
  final List<SearchShop> shops;

  const SearchShopsLoaded(this.shops);

  @override
  List<Object?> get props => [shops];
}

class SearchShopsError extends SearchShopsState {
  final String message;

  const SearchShopsError(this.message);

  @override
  List<Object?> get props => [message];
} 