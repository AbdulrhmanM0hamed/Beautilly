import 'package:beautilly/features/Home/data/models/service_model.dart';

import '../../domain/entities/search_shop.dart';

abstract class SearchShopsState {
  const SearchShopsState();
}

class SearchShopsInitial extends SearchShopsState {}

class SearchShopsLoading extends SearchShopsState {}

class SearchShopsLoaded extends SearchShopsState {
  final List<SearchShop> shops;
  final Pagination pagination;

  const SearchShopsLoaded(this.shops, this.pagination);
}

class SearchShopsError extends SearchShopsState {
  final String message;

  const SearchShopsError(this.message);
}

class SearchShopsTypeLoaded extends SearchShopsState {
  final List<ShopModel> shops;
  const SearchShopsTypeLoaded(this.shops);
} 