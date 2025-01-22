import 'package:beautilly/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_state.dart';
import 'package:beautilly/features/orders/presentation/view/widgets/my_orders_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';


class TailoringRequestsPage extends StatefulWidget {
  const TailoringRequestsPage({super.key});

  @override
  State<TailoringRequestsPage> createState() => _TailoringRequestsPageState();
}

class _TailoringRequestsPageState extends State<TailoringRequestsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrdersCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('طلبات التفصيل'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'طلباتي'),
              Tab(text: 'طلبات المستخدمين'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            MyOrdersWidget(),
            AllOrdersWidget(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // إضافة طلب تفصيل جديد
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

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
              return OrderCard(order: order);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
} 