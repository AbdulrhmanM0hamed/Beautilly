import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/get_discounts_usecase.dart';
import 'discounts_state.dart';
import '../../../domain/entities/discount.dart';
import '../../../domain/repositories/discounts_repository.dart';

class DiscountsCubit extends Cubit<DiscountsState> {
  final DiscountsRepository repository;
  int _currentPage = 1;
  bool _isLastPage = false;
  List<Discount> _currentDiscounts = [];

  DiscountsCubit({required this.repository}) : super(DiscountsInitial());

  Future<void> loadDiscounts() async {
    emit(DiscountsLoading());
    _currentPage = 1;
    _currentDiscounts = [];
    
    final result = await repository.getDiscounts(page: _currentPage);
    
    result.fold(
      (failure) => emit(DiscountsError(failure.message)),
      (response) {
        _currentDiscounts = response.discounts;
        _isLastPage = response.pagination.currentPage >= response.pagination.lastPage;
        emit(DiscountsLoaded(
          discounts: _currentDiscounts,
          isLastPage: _isLastPage,
        ));
      },
    );
  }

  Future<void> loadMoreDiscounts() async {
    if (_isLastPage) return;
    
    _currentPage++;
    final result = await repository.getDiscounts(page: _currentPage);
    
    result.fold(
      (failure) => emit(DiscountsError(failure.message)),
      (response) {
        _currentDiscounts.addAll(response.discounts);
        _isLastPage = response.pagination.currentPage >= response.pagination.lastPage;
        emit(DiscountsLoaded(
          discounts: _currentDiscounts,
          isLastPage: _isLastPage,
        ));
      },
    );
  }
}
