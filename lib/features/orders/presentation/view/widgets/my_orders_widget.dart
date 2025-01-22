import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/order.dart';
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
          return const Center(child: CircularProgressIndicator());
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
              return OrderCard(order: order);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderEntity order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طلب #${order.id}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  order.statusLabel,
                  style: TextStyle(
                    color: order.status == 'completed' 
                        ? Colors.green 
                        : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(order.description),
            const SizedBox(height: 8),
            if (order.mainImage.thumb.isNotEmpty)
              Image.network(
                order.mainImage.thumb,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 8),
            Text('المقاسات: ${order.height}سم × ${order.weight}كجم'),
            Text('القياس: ${order.size}'),
            if (order.fabrics.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('الأقمشة:'),
              Wrap(
                spacing: 8,
                children: order.fabrics.map((fabric) => Chip(
                  label: Text(fabric.type),
                  backgroundColor: Color(
                    int.parse(
                      fabric.color.replaceAll('#', '0xFF'),
                    ),
                  ),
                )).toList(),
              ),
            ],
            const SizedBox(height: 8),
            Text('تاريخ الطلب: ${order.createdAt}'),
          ],
        ),
      ),
    );
  }
} 