import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/shop_type.dart';
import '../../domain/repositories/search_shops_repository.dart';
import 'search_shops_state.dart';

class SearchShopsCubit extends Cubit<SearchShopsState> {
  final SearchShopsRepository repository;
  ShopType selectedType = ShopType.all;
  String? searchQuery;

  SearchShopsCubit({required this.repository}) : super(SearchShopsInitial()) {
    // تحميل كل المتاجر عند البداية
    filterShops();
  }

  Future<void> filterShops() async {
    emit(SearchShopsLoading());
    
    final type = selectedType == ShopType.all ? null : selectedType.name;
    
    final result = await repository.filterShops(
      type: type,
      search: searchQuery,
    );
    
    result.fold(
      (failure) => emit(SearchShopsError(failure.message)),
      (shops) => emit(SearchShopsLoaded(shops)),
    );
  }

  void changeType(ShopType type) {
    selectedType = type;
    filterShops();
  }

  void updateSearch(String query) {
    searchQuery = query.isEmpty ? null : query;
    filterShops();
  }
} 