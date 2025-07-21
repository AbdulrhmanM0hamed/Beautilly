import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:beautilly/features/orders/presentation/cubit/orders_state.dart';
import 'package:beautilly/features/orders/presentation/view/widgets/order_card.dart';
import 'package:beautilly/features/orders/presentation/view/widgets/order_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllOrdersWidget extends StatefulWidget {
  const AllOrdersWidget({super.key});

  @override
  State<AllOrdersWidget> createState() => _AllOrdersWidgetState();
}

class _AllOrdersWidgetState extends State<AllOrdersWidget> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<OrdersCubit>().loadAllOrders(page: _currentPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      final ordersCubit = context.read<OrdersCubit>();
      if (ordersCubit.canLoadMoreAllOrders) {
        _currentPage++;
        ordersCubit.loadAllOrders(page: _currentPage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading && _currentPage == 1) {
          final size = MediaQuery.of(context).size;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(size.width),
              childAspectRatio: _getChildAspectRatio(size.width),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 6,
            itemBuilder: (context, index) => const OrderCardShimmer(),
          );
        }

        if (state is AllOrdersSuccess) {
          if (state.orders.isEmpty) {
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
              _currentPage = 1;
              await context.read<OrdersCubit>().loadAllOrders(page: 1);
            },
            child: Stack(
              children: [
                GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(MediaQuery.of(context).size.width),
                    childAspectRatio: _getChildAspectRatio(MediaQuery.of(context).size.width),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.orders.length + (context.read<OrdersCubit>().canLoadMoreAllOrders ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.orders.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      );
                    }
                    return OrderCard(
                      order: state.orders[index],
                      isMyRequest: false,
                    );
                  },
                ),
                if (state is OrdersLoading && _currentPage > 1)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withValues(alpha:0.1),
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    ),
                  ),
              ],
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
                    _currentPage = 1;
                    context.read<OrdersCubit>().loadAllOrders(page: 1);
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
    if (width >= 1200) return 4;      // Desktop - زيادة عدد الأعمدة
    if (width >= 800) return 3;       // Tablet
    return 2;                         // Mobile
  }

  double _getChildAspectRatio(double width) {
    if (width >= 1200) return 1.0;    // Desktop
    if (width >= 800) return 0.85;    // Tablet
    if (width > 600) return 0.80;     // Large Tablet
    if (width >= 400) return 0.70;    // Small Tablet
    return 0.65;                      // Mobile
  }
}

