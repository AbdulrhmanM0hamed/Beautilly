import 'package:beautilly/features/Home/domain/entities/service_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services_state.dart';
import '../../../domain/repositories/services_repository.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ServicesRepository repository;
  int _currentPage = 1;
  bool _isLastPage = false;
  List<ServiceEntity> _currentServices = [];
  bool _isLoading = false;

  ServicesCubit({required this.repository}) : super(ServicesInitial());

  Future<void> loadServices() async {
    emit(ServicesLoading());
    _currentPage = 1;
    _currentServices = [];
    _isLoading = false;
    
    final result = await repository.getServices(page: _currentPage);
    
    result.fold(
      (failure) => emit(ServicesError(failure.message)),
      (response) {
        _currentServices = response.services;
        _isLastPage = response.pagination.currentPage >= response.pagination.lastPage;
        emit(ServicesLoaded(
          services: _currentServices,
          isLastPage: _isLastPage,
        ));
      },
    );
  }

  Future<void> loadMoreServices() async {
    if (_isLastPage || _isLoading) return;
    
    _isLoading = true;
    emit(ServicesLoading(isLoadingMore: true));
    
    final nextPage = _currentPage + 1;
    final result = await repository.getServices(page: nextPage);
    
    result.fold(
      (failure) {
        _isLoading = false;
        emit(ServicesError(failure.message));
      },
      (response) {
        if (response.services.isNotEmpty) {
          _currentPage = nextPage;
          _currentServices.addAll(response.services);
          _isLastPage = nextPage >= response.pagination.lastPage;
        } else {
          _isLastPage = true;
        }
        _isLoading = false;
        
        emit(ServicesLoaded(
          services: _currentServices,
          isLastPage: _isLastPage,
        ));
      },
    );
  }

  Future<void> searchServices(String query) async {
    emit(ServicesLoading());
    final result = await repository.searchServices(query);
    result.fold(
      (failure) => emit(ServicesError(failure.message)),
      (services) => emit(ServicesLoaded(
        services: services,
        isLastPage: true,
      )),
    );
  }
} 