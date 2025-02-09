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
          final newStatus = offer.status == 'accepted' ? 'pending' : 'accepted';
          return OfferWithDetails(
            id: offer.id,
            price: offer.price,
            notes: offer.notes,
            daysCount: offer.daysCount,
            status: newStatus,
            createdAt: offer.createdAt,
            shop: offer.shop as ShopWithDetails,
          );
        }
        return OfferWithDetails(
          id: offer.id,
          price: offer.price,
          notes: offer.notes,
          daysCount: offer.daysCount,
          status: 'pending',
          createdAt: offer.createdAt,
          shop: offer.shop as ShopWithDetails,
        );
      }).toList();

      emit(OrderDetailsSuccess(
        currentState.orderDetails.copyWith(
          offers: updatedOffers,
        ),
      ));
    }
  }
} 