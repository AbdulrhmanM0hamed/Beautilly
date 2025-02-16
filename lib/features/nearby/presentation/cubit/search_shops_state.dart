import 'package:beautilly/features/Home/data/models/service_model.dart';


abstract class SearchShopsState {
  const SearchShopsState();
}

class SearchShopsInitial extends SearchShopsState {}

class SearchShopsLoading extends SearchShopsState {}

class SearchShopsLoaded extends SearchShopsState {
  final List<dynamic> shops;

  const SearchShopsLoaded(this.shops);
}

class SearchShopsError extends SearchShopsState {
  final String message;

  const SearchShopsError(this.message);
}

class SearchShopsTypeLoaded extends SearchShopsState {
  final List<ShopModel> shops;
  const SearchShopsTypeLoaded(this.shops);
} 