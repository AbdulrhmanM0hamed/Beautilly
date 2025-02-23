import 'package:beautilly/core/utils/navigation/custom_page_route.dart';
import 'package:beautilly/features/salone_profile/presentation/view/salone_profile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/utils/constant/font_manger.dart';
import '../../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../../core/utils/theme/app_colors.dart';
import '../../../../domain/entities/favorite_shop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../features/salone_profile/presentation/cubit/favorites_cubit/toggle_favorites_cubit.dart';
import '../../../../../../features/salone_profile/presentation/cubit/favorites_cubit/toggle_favorites_state.dart';

class FavoriteShopCard extends StatelessWidget {
  final FavoriteShop shop;
  final VoidCallback? onRemoved;

  const FavoriteShopCard({
    super.key,
    required this.shop,
    this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ToggleFavoritesCubit, ToggleFavoritesState>(
      listener: (context, state) {
        if (state is ToggleFavoritesSuccess && !state.isFavorite) {
          onRemoved?.call();
        } else if (state is ToggleFavoritesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                PageRoutes.fadeScale(
                  page: SalonProfileView(salonId: shop.id),
                ),
              );
              // التنقل إلى صفحة المتجر
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المتجر مع Overlay
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: shop.image,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error),
                        ),
                      ),
                    ),
                    // Gradient Overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Shop Type Badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          shop.type == 'tailor' ? 'دار ازياء' : 'صالون',
                          style: getMediumStyle(
                            color: Colors.white,
                            fontSize: FontSize.size12,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // معلومات المتجر
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                shop.name,
                                style: getBoldStyle(
                                  fontSize: FontSize.size14,
                                  fontFamily: FontConstant.cairo,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildFavoriteButton(),
                          ],
                        ),
                        const Spacer(),
                        // Metrics Row
                        Row(
                          children: [
                            _buildMetricChip(
                              icon: Icons.star,
                              label: shop.rating,
                              color: const Color(0xFFFFB800),
                            ),
                            const SizedBox(width: 8),
                            _buildMetricChip(
                              icon: Icons.favorite,
                              label: '${shop.lovesCount}',
                              color: AppColors.error,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return BlocBuilder<ToggleFavoritesCubit, ToggleFavoritesState>(
      builder: (context, state) {
        final isLoading = state is ToggleFavoritesLoading;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: isLoading
                ? null
                : () {
                    context
                        .read<ToggleFavoritesCubit>()
                        .removeFromFavorites(shop.id);
                  },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.error,
                      ),
                    )
                  : const Icon(
                      Icons.favorite,
                      color: AppColors.error,
                      size: 20,
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    // تنسيق الرقم إذا كان تقييم
    String displayLabel = label;
    if (icon == Icons.star) {
      try {
        final rating = double.parse(label);
        displayLabel = rating.toStringAsFixed(1);
      } catch (_) {}
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            displayLabel,
            style: getMediumStyle(
              color: color,
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}
