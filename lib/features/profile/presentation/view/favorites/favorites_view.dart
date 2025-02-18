import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/profile/presentation/cubit/favorites_cubit/favorites_cubit.dart';
import 'package:beautilly/features/profile/presentation/cubit/favorites_cubit/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../../../../core/utils/common/custom_app_bar.dart';
import '../../../../../core/utils/responsive/app_responsive.dart';
import 'widgets/favorite_shop_card.dart';
import '../../../../../../features/salone_profile/presentation/cubit/favorites_cubit/toggle_favorites_cubit.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= AppResponsive.tabletBreakpoint;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ToggleFavoritesCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'المفضلة',
        ),
        body: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return const Center(
                child: CustomProgressIndcator(color: AppColors.primary),
              );
            }

            if (state is FavoritesError) {
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
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.red[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<FavoritesCubit>().loadFavorites();
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

            if (state is FavoritesLoaded) {
              if (state.favorites.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد متاجر في المفضلة',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<FavoritesCubit>().loadFavorites();
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
                    itemCount: state.favorites.length,
                    itemBuilder: (context, index) => BlocProvider(
                      create: (context) => sl<ToggleFavoritesCubit>(),
                      child: FavoriteShopCard(
                        shop: state.favorites[index],
                        onRemoved: () {
                          context.read<FavoritesCubit>().loadFavorites();
                        },
                      ),
                    ),
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1200) return 4;      // Desktop
    if (width >= 800) return 3;       // Tablet
    return 2;                         // Mobile
  }

  double _getChildAspectRatio(double width) {
    if (width >= 1000) return 1.07;   // Desktop
    if (width >= 800) return 0.85;    // Tablet
    if (width > 600) return 0.75;     // Large Tablet
    if (width >= 400) return 0.70;    // Small Tablet
    return 0.60;                      // Mobile
  }
}
