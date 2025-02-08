import 'package:beautilly/core/utils/common/custom_app_bar.dart';

import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/orders/presentation/cubit/delete_order_cubit/delete_order_cubit.dart';
import 'package:beautilly/features/orders/presentation/cubit/delete_order_cubit/delete_order_state.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_state.dart';
import 'package:beautilly/features/orders/presentation/view/add_order_view.dart';
import 'package:beautilly/features/orders/presentation/view/widgets/all_oreder_widget.dart';
import 'package:beautilly/features/orders/presentation/view/widgets/my_orders_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';

class OrdersRequestsView extends StatefulWidget {
  const OrdersRequestsView({super.key});

  @override
  State<OrdersRequestsView> createState() => _OrdersRequestsViewState();
}

class _OrdersRequestsViewState extends State<OrdersRequestsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late OrdersCubit _ordersCubit;
  late DeleteOrderCubit _deleteOrderCubit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _ordersCubit = sl<OrdersCubit>();
    _deleteOrderCubit = sl<DeleteOrderCubit>();
    _ordersCubit.loadMyOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ordersCubit.close();
    _deleteOrderCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: _ordersCubit,
        ),
        BlocProvider.value(
          value: _deleteOrderCubit,
        ),
      ],
      child: BlocListener<DeleteOrderCubit, DeleteOrderState>(
        listener: (context, state) {
          if (state is DeleteOrderSuccess) {
            CustomSnackbar.showSuccess(
                context: context, message: 'تم حذف الطلب بنجاح');
            _ordersCubit.loadMyOrders();
          } else if (state is DeleteOrderError) {
            CustomSnackbar.showError(
              context: context,
              message: state.message,
            );
          }
        },
        child: Builder(
          builder: (context) => Scaffold(
            appBar: CustomAppBar(
              title: 'طلبات التفصيل',
              bottom: TabBar(
                controller: _tabController,
                onTap: (index) {
                  if (index == 0) {
                    _ordersCubit.loadMyOrders();
                  } else {
                    _ordersCubit.loadAllOrders();
                  }
                },
                tabs: const [
                  Tab(text: 'طلباتي'),
                  Tab(text: 'طلبات المستخدمين'),
                ],
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                if (_tabController.index == 0) {
                  _ordersCubit.loadMyOrders();
                } else {
                  _ordersCubit.loadAllOrders();
                }
              },
              color: AppColors.primary,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: TabBarView(
                controller: _tabController,
                children: const [
                  MyOrdersWidget(),
                  AllOrdersWidget(),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final result =
                    await Navigator.pushNamed(context, AddOrderView.routeName);
                if (result == true && mounted) {
                  _ordersCubit.loadMyOrders();
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}

class RefreshableOrdersList extends StatefulWidget {
  final Widget child;

  const RefreshableOrdersList({
    super.key,
    required this.child,
  });

  @override
  State<RefreshableOrdersList> createState() => _RefreshableOrdersListState();
}

class _RefreshableOrdersListState extends State<RefreshableOrdersList> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    if (widget.child is MyOrdersWidget) {
      context.read<OrdersCubit>().loadMyOrders();
    } else if (widget.child is AllOrdersWidget) {
      context.read<OrdersCubit>().loadAllOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is OrdersSuccess) {
          // تم تحميل البيانات بنجاح
        } else if (state is OrdersError) {
          CustomSnackbar.showSuccess(
            context: context,
            message: state.message,
          );
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        color: AppColors.primary,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        displacement: 20,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: widget.child,
      ),
    );
  }
}
