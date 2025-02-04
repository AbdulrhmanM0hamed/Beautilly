import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_services_usecase.dart';
import 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final GetServices getServices;

  ServicesCubit({required this.getServices}) : super(ServicesInitial());

  Future<void> loadServices() async {
    emit(ServicesLoading());
    
    final result = await getServices();
    
    result.fold(
      (failure) => emit(ServicesError(failure.message)),
      (services) => emit(ServicesLoaded(services)),
    );
  }
} 