import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/responsive/app_responsive.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';
import 'package:beautilly/features/orders/presentation/cubit/delete_order_cubit/delete_order_cubit.dart';
import 'package:beautilly/features/orders/presentation/cubit/delete_order_cubit/delete_order_state.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_state.dart';
import 'package:beautilly/features/orders/presentation/view/add_order_view.dart';
import 'package:beautilly/features/orders/presentation/view/widgets/all_oreder_widget.dart';
import 'package:beautilly/features/orders/presentation/view/widgets/order_card.dart';
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
          body: BlocListener<DeleteOrderCubit, DeleteOrderState>(
            listener: (context, state) {
              if (state is DeleteOrderSuccess) {
                CustomSnackbar.showSuccess(
                  context: context,
                  message: 'تم حذف الطلب بنجاح',
                );
                _ordersCubit.loadMyOrders();
              } else if (state is DeleteOrderError) {
                CustomSnackbar.showError(
                  context: context,
                  message: state.message,
                );
              }
            },
            child: TabBarView(
              controller: _tabController,
              children: const [
                MyOrdersWidget(),
                AllOrdersWidget(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                AddOrderView.routeName,
              );
              if (result == true && mounted) {
                _ordersCubit.loadMyOrders();
              }
            },
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add),
            label: Text(
              'إضافة طلب تفصيل',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                color: Colors.white,
                fontSize: FontSize.size14,
              ),
            ),
            elevation: 2,
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

class MyOrdersWidget extends StatelessWidget {
  const MyOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= AppResponsive.mobileBreakpoint;
    final isDesktop = size.width >= AppResponsive.tabletBreakpoint;

    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(
            child: CustomProgressIndcator(color: AppColors.primary),
          );
        }

        if (state is OrdersSuccess) {
          final orders = state.orders;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.design_services_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد طلبات',
                    style: getMediumStyle(
                      color: Colors.grey[600]!,
                      fontSize: FontSize.size16,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<OrdersCubit>().loadMyOrders();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: isDesktop ? 24 : 16,
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(size.width),
                  childAspectRatio: _getChildAspectRatio(size.width),
                  crossAxisSpacing: isDesktop ? 24 : 16,
                  mainAxisSpacing: isDesktop ? 24 : 16,
                ),
                itemCount: orders.length,
                itemBuilder: (context, index) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: context.read<OrdersCubit>(),
                    ),
                    BlocProvider.value(
                      value: context.read<DeleteOrderCubit>(),
                    ),
                  ],
                  child: OrderCard(
                    order: orders[index],
                    isMyRequest: true,
                    onDelete: (id) {
                      context.read<DeleteOrderCubit>().deleteOrder(id);
                    },
                  ),
                ),
              ),
            ),
          );
        }

        if (state is OrdersError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: getMediumStyle(
                    color: Colors.red[600]!,
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<OrdersCubit>().loadMyOrders();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1200) return 3; // Desktop
    if (width >= 800) return 3; // Tablet
    return 2; // Mobile
  }

  double _getChildAspectRatio(double width) {
    if (width >= 1000) return 0.68; // Desktop - تقليل الارتفاع
    if (width == 800) return 0.48;
    if (width > 800) return 0.58;
    if (width >= 400 && width <= 600) return 0.55;
    if (width == 360) return 0.50;
    if (width >= 320 && width <= 390) return 0.46;
    
    return 0.65; // Mobile
  }
}
