import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/profile/presentation/cubit/favorites_cubit/favorites_cubit.dart';
import 'package:beautilly/features/profile/presentation/cubit/favorites_cubit/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../../../../core/utils/common/custom_app_bar.dart';
import 'widgets/favorite_shop_card.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'المفضلة',
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(
                child: CustomProgressIndcator(
              color: AppColors.primary,
            ));
          }

          if (state is FavoritesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<FavoritesCubit>().loadFavorites();
                    },
                    child: const Text('إعادة المحاولة'),
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                return FavoriteShopCard(
                  shop: state.favorites[index],
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
