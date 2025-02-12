import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_services_usecase.dart';
import 'service_shops_state.dart';

class ServiceShopsCubit extends Cubit<ServiceShopsState> {
  final GetServices getServices;

  ServiceShopsCubit({
    required this.getServices,
  }) : super(ServiceShopsInitial());

  Future<void> loadShopsByIds(List<int> shopIds) async {
    try {
      emit(ServiceShopsLoading());
      final result = await getServices();
      
      result.fold(
        (failure) => emit(ServiceShopsError(message: failure.message)),
        (services) {
          // نجد الخدمة التي تحتوي على هذه المتاجر
          final service = services.firstWhere(
            (service) => service.shops.any((shop) => shopIds.contains(shop.id))
          );
          
          // نأخذ فقط المتاجر المطلوبة من هذه الخدمة
          final serviceShops = service.shops
              .where((shop) => shopIds.contains(shop.id))
              .toList();
              
          emit(ServiceShopsLoaded(shops: serviceShops));
        },
      );
    } catch (e) {
      emit(ServiceShopsError(message: e.toString()));
    }
  }
} 