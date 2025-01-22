import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/features/orders/presentation/view/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/orders_cubit.dart';
import '../../cubit/orders_state.dart';
import '../../../../../core/services/service_locator.dart';

class MyOrdersWidget extends StatelessWidget {
  const MyOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrdersCubit>()..loadMyOrders(),
      child: const MyOrdersContent(),
    );
  }
}

class MyOrdersContent extends StatefulWidget {
  const MyOrdersContent({super.key});

  @override
  State<MyOrdersContent> createState() => _MyOrdersContentState();
}

class _MyOrdersContentState extends State<MyOrdersContent> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(child: CustomProgressIndcator());
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
              return OrderCard(order: order, isMyRequest: true);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

