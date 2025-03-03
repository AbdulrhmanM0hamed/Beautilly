import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/search_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository searchRepository;
  
  SearchCubit({required this.searchRepository}) : super(SearchInitial());

  Future<void> searchShops(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    final result = await searchRepository.searchShops(query: query);
    
    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (shops) => emit(SearchSuccess(shops)),
    );
  }
}
