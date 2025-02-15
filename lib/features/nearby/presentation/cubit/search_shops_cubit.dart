import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/shop_type.dart';
import '../../domain/repositories/search_shops_repository.dart';
import 'search_shops_state.dart';

class SearchShopsCubit extends Cubit<SearchShopsState> {
  final SearchShopsRepository repository;
  ShopType _selectedType = ShopType.all;
  String _searchQuery = '';

  SearchShopsCubit({required this.repository}) : super(SearchShopsInitial()) {
    // Load initial data
    loadInitialData();
  }

  ShopType get selectedType => _selectedType;

  Future<void> loadInitialData() async {
    emit(SearchShopsLoading());
    try {
      // Load initial data with empty query to get all shops
      final result = await repository.searchShops(
        query: '',
        type: null, // Get all types initially
      );

      result.fold(
        (failure) => emit(SearchShopsError(failure.message)),
        (shops) => emit(SearchShopsLoaded(shops)),
      );
    } catch (e) {
      emit(const SearchShopsError('حدث خطأ في تحميل البيانات'));
    }
  }

  Future<void> searchShops({required String query}) async {
    _searchQuery = query;
    emit(SearchShopsLoading());
    try {
      final result = await repository.searchShops(
        query: query,
        type: _selectedType == ShopType.all ? null : _selectedType.apiValue,
      );

      result.fold(
        (failure) => emit(SearchShopsError(failure.message)),
        (shops) => emit(SearchShopsLoaded(shops)),
      );
    } catch (e) {
      emit(const SearchShopsError('حدث خطأ في البحث'));
    }
  }

  Future<void> changeType(ShopType type) async {
    if (_selectedType != type) {
      _selectedType = type;
      try {
        emit(SearchShopsLoading());
        final result = await repository.searchShops(
          query: _searchQuery,
          type: type == ShopType.all ? null : type.apiValue,
        );

        result.fold(
          (failure) => emit(SearchShopsError(failure.message)),
          (shops) => emit(SearchShopsLoaded(shops)),
        );
      } catch (e) {
        emit(const SearchShopsError('حدث خطأ في تحميل البيانات'));
      }
    }
  }

  void clearSearch() {
    _searchQuery = '';
    searchShops(query: '');
  }
} 