import 'package:beautilly/features/orders/domain/entities/order_details.dart';
import 'package:beautilly/features/orders/domain/repositories/orders_repository.dart';
import 'package:beautilly/features/orders/presentation/cubit/order_details_cubit/order_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final OrdersRepository _ordersRepository;

  OrderDetailsCubit(this._ordersRepository) : super(OrderDetailsInitial());

  Future<void> getOrderDetails(int orderId) async {
    emit(OrderDetailsLoading());
    
    final result = await _ordersRepository.getOrderDetails(orderId);
    
    result.fold(
      (failure) => emit(OrderDetailsError(failure.message)),
      (orderDetails) => emit(OrderDetailsSuccess(orderDetails)),
    );
  }

  void updateOfferStatus(int offerId) {
    if (state is OrderDetailsSuccess) {
      final currentState = state as OrderDetailsSuccess;
      final updatedOffers = currentState.orderDetails.offers.map((offer) {
        if (offer.id == offerId) {
          return OfferWithDetails(
            id: offer.id,
            price: offer.price,
            daysCount: offer.daysCount,
            notes: offer.notes,
            status: 'accepted',
            shop: offer.shop as ShopWithDetails,
            createdAt: offer.createdAt,
          );
        }
        return offer;
      }).toList();

      emit(OrderDetailsSuccess(
        OrderDetails(
          id: currentState.orderDetails.id,
          description: currentState.orderDetails.description,
          status: currentState.orderDetails.status,
          statusLabel: currentState.orderDetails.statusLabel,
          height: currentState.orderDetails.height,
          weight: currentState.orderDetails.weight,
          size: currentState.orderDetails.size,
          fabrics: currentState.orderDetails.fabrics,
          executionTime: currentState.orderDetails.executionTime,
          createdAt: currentState.orderDetails.createdAt,
          updatedAt: currentState.orderDetails.updatedAt,
          customer: currentState.orderDetails.customer,
          images: currentState.orderDetails.images,
          offers: updatedOffers,
        ),
      ));
    }
  }
} 