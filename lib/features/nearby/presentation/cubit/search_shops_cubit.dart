import 'package:beautilly/features/nearby/domain/entities/search_shop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/shop_type.dart';
import '../../domain/repositories/search_shops_repository.dart';
import 'search_shops_state.dart';

class SearchShopsCubit extends Cubit<SearchShopsState> {
  final SearchShopsRepository repository;
  ShopType selectedType = ShopType.all;
  String? searchQuery;
  List<SearchShop> currentShops = [];

  SearchShopsCubit({required this.repository}) : super(SearchShopsInitial()) {
    filterShops();
  }

  Future<void> filterShops() async {
    emit(SearchShopsLoading());
    
    final type = selectedType == ShopType.all ? null : selectedType.name;
    
    final result = await repository.filterShops(
      type: type,
      search: searchQuery,
      page: 1, // إعادة تعيين الصفحة عند البحث الجديد
    );
    
    result.fold(
      (failure) => emit(SearchShopsError(failure.message)),
      (response) {
        currentShops = response.shops;
        if (isClosed) return;
        emit(SearchShopsLoaded(response.shops, response.pagination));
      },
    );
  }

  Future<void> loadMoreShops({required int page}) async {
    final type = selectedType == ShopType.all ? null : selectedType.name;
    
    final result = await repository.filterShops(
      type: type,
      search: searchQuery,
      page: page,
    );
    
    result.fold(
      (failure) => emit(SearchShopsError(failure.message)),
      (response) {
        currentShops = [...currentShops, ...response.shops];
        if (!isClosed) {
          
          emit(SearchShopsLoaded(currentShops, response.pagination));
        }
      },
    );
  }

  void resetPagination() {
    currentShops = [];
    filterShops();
  }

  void changeType(ShopType type) {
    selectedType = type;
    resetPagination();
  }

  void updateSearch(String query) {
    searchQuery = query.isEmpty ? null : query;
    resetPagination();
  }
} 
