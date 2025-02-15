import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_services_usecase.dart';
import 'services_state.dart';
import '../../../domain/repositories/services_repository.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ServicesRepository _servicesRepository;

  ServicesCubit(this._servicesRepository) : super(ServicesInitial()) {
    getServices();
  }

  Future<void> getServices() async {
    emit(ServicesLoading());
    final result = await _servicesRepository.getServices();
    result.fold(
      (failure) => emit(ServicesError(failure.message)),
      (services) => emit(ServicesLoaded(services)),
    );
  }

  Future<void> searchServices(String query) async {
    emit(ServicesLoading());
    final result = await _servicesRepository.searchServices(query);
    result.fold(
      (failure) => emit(ServicesError(failure.message)),
      (services) => emit(ServicesLoaded(services)),
    );
  }
} 