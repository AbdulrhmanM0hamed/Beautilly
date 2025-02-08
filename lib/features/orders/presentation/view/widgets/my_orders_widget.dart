import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/orders/domain/usecases/delete_order_usecase.dart';
import 'package:beautilly/features/orders/presentation/view/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/orders_cubit.dart';
import '../../cubit/orders_state.dart';
import '../../../../../core/services/service_locator.dart';
import '../../cubit/delete_order_cubit/delete_order_cubit.dart';
import '../../cubit/delete_order_cubit/delete_order_state.dart';

class MyOrdersWidget extends StatefulWidget {
  const MyOrdersWidget({super.key});

  @override
  State<MyOrdersWidget> createState() => _MyOrdersWidgetState();
}

class _MyOrdersWidgetState extends State<MyOrdersWidget> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteOrderCubit(
        deleteOrderUseCase: sl<DeleteOrderUseCase>(),
      ),
      child: BlocConsumer<DeleteOrderCubit, DeleteOrderState>(
        listener: (context, state) {
          if (state is DeleteOrderSuccess) {
            CustomSnackbar.showSuccess(
              context: context,
              message: 'تم حذف الطلب بنجاح',
            );
            context.read<OrdersCubit>().loadMyOrders();
          } else if (state is DeleteOrderError) {
            CustomSnackbar.showError(
              context: context,
              message: state.message,
            );
          }
        },
        builder: (context, deleteState) {
          return Stack(
            children: [
              BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  if (state is OrdersLoading) {
                    return const Center(
                      child: CustomProgressIndcator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (state is OrdersError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          TextButton(
                            onPressed: () {
                              context.read<OrdersCubit>().loadMyOrders();
                            },
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is OrdersSuccess) {
                    if (state.orders.isEmpty) {
                      return const Center(child: Text('لا توجد طلبات'));
                    }
                    return ListView.builder(
                      itemCount: state.orders.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final order = state.orders[index];
                        return OrderCard(
                          order: order,
                          isMyRequest: true,
                          onDelete: (orderId) {
                            context.read<DeleteOrderCubit>().deleteOrder(orderId);
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
              if (deleteState is DeleteOrderLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CustomProgressIndcator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
