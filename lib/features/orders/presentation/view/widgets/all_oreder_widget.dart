import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_state.dart';
import 'package:beautilly/features/orders/presentation/view/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllOrdersWidget extends StatefulWidget {
  const AllOrdersWidget({super.key});

  @override
  State<AllOrdersWidget> createState() => _AllOrdersWidgetState();
}

class _AllOrdersWidgetState extends State<AllOrdersWidget> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(child: CustomProgressIndcator(
            color: AppColors.primary,
          ));
        }

        if (state is OrdersError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<OrdersCubit>().loadAllOrders();
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
              return OrderCard(order: order, isMyRequest: false);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
