import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/common/custom_app_bar.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Home/presentation/cubit/premium_shops_cubit/premium_shops_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/premium_shops_cubit/premium_shops_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/responsive/app_responsive.dart';
import 'widgets/premium_salon_grid_card.dart';

class AllPremiumSalonsView extends StatefulWidget {
  const AllPremiumSalonsView({super.key});

  @override
  State<AllPremiumSalonsView> createState() => _AllPremiumSalonsViewState();
}

class _AllPremiumSalonsViewState extends State<AllPremiumSalonsView> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;
    await context.read<PremiumShopsCubit>().loadPremiumShops(
      page: _currentPage,
      isLoadingMore: true,
    );

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final crossAxisCount = size.width >= AppResponsive.tabletBreakpoint 
        ? 3 
        : size.width >= AppResponsive.mobileBreakpoint 
            ? 2 
            : 2;

    return BlocProvider(
      create: (context) => sl<PremiumShopsCubit>()..loadPremiumShops(),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'أشهر صالونات التجميل',
        ),
        body: BlocBuilder<PremiumShopsCubit, PremiumShopsState>(
          builder: (context, state) {
            if (state is PremiumShopsLoading && !_isLoadingMore) {
              return const Center(child: CustomProgressIndcator(
                color: AppColors.primary,
              ));
            }

            if (state is PremiumShopsError && !_isLoadingMore) {
              return Center(child: Text(state.message));
            }

            if (state is PremiumShopsLoaded) {
              final salons = state.shops.where((shop) => shop.type == 'salon').toList();
              
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: MasonryGridView.count(
                        controller: _scrollController,
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        itemBuilder: (context, index) {
                          final salon = salons[index];
                          return PremiumSalonGridCard(
                            salon: salon,
                            index: index,
                          );
                        },
                        itemCount: salons.length,
                      ),
                    ),
                    if (_isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomProgressIndcator(
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
} 