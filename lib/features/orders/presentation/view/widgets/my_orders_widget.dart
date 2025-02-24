import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/responsive/app_responsive.dart';
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
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<OrdersCubit>().loadMyOrders(page: _currentPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      final ordersCubit = context.read<OrdersCubit>();
      if (ordersCubit.canLoadMoreMyOrders) {
        _currentPage++;
        ordersCubit.loadMyOrders(page: _currentPage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= AppResponsive.tabletBreakpoint;

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
          return BlocBuilder<OrdersCubit, OrdersState>(
            builder: (context, state) {
              if (state is OrdersLoading && _currentPage == 1) {
                return const Center(
                  child: CustomProgressIndcator(color: AppColors.primary),
                );
              }

              if (state is MyOrdersSuccess) {
                final orders = state.orders;
                final pagination = state.pagination;

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
                    _currentPage = 1;
                    await context.read<OrdersCubit>().loadMyOrders(page: 1);
                  },
                  child: Stack(
                    children: [
                      GridView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: isDesktop ? 24 : 16,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _getCrossAxisCount(size.width),
                          childAspectRatio: _getChildAspectRatio(size.width),
                          crossAxisSpacing: isDesktop ? 24 : 16,
                          mainAxisSpacing: isDesktop ? 24 : 16,
                        ),
                        itemCount: orders.length + (context.read<OrdersCubit>().canLoadMoreMyOrders ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == orders.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(color: AppColors.primary),
                              ),
                            );
                          }
                          return OrderCard(
                            order: orders[index],
                            isMyRequest: true,
                            onDelete: (id) {
                              context.read<DeleteOrderCubit>().deleteOrder(id);
                            },
                          );
                        },
                      ),
                      if (state is OrdersLoading && _currentPage > 1)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.1),
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
                          context.read<OrdersCubit>().loadMyOrders(page: 1);
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
        },
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= AppResponsive.tabletBreakpoint) {
      return 3;
    } else if (width >= AppResponsive.mobileBreakpoint) {
      return 2;
    } else {
      return 1;
    }
  }

  double _getChildAspectRatio(double width) {
    if (width >= AppResponsive.tabletBreakpoint) {
      return 1.5;
    } else if (width >= AppResponsive.mobileBreakpoint) {
      return 1.0;
    } else {
      return 1.0;
    }
  }
}
