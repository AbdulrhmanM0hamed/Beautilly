import 'package:beautilly/core/services/cache/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/orders_service.dart';
import '../../../data/models/order_model.dart';

class MyOrdersWidget extends StatefulWidget {
  const MyOrdersWidget({super.key});

  @override
  State<MyOrdersWidget> createState() => _MyOrdersWidgetState();
}

class _MyOrdersWidgetState extends State<MyOrdersWidget> {
  bool _isLoading = false;
  String? _error;
  List<OrderModel>? _orders;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final ordersService = OrdersService(context.read<CacheService>());
      final orders = await ordersService.getMyOrders();
      
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrders,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_orders == null || _orders!.isEmpty) {
      return const Center(child: Text('لا توجد طلبات'));
    }

    return ListView.builder(
      itemCount: _orders!.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final order = _orders![index];
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
      },
    );
  }
} 