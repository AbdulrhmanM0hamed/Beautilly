import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/favorites_cubit/toggle_favorites_cubit.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/favorites_cubit/toggle_favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';

class BeautyServiceCard extends StatelessWidget {
  final String image;
  final String name;
  final String location;
  final double rating;
  final int ratingCount;
  final List<String>? tags;
  final bool isFavorite;
  final int shopId;
  final Function()? onFavoritePressed;

  const BeautyServiceCard({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    required this.rating,
    required this.ratingCount,
    required this.shopId,
    this.tags,
    this.isFavorite = false,
    this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions =
        ResponsiveCardSizes.getBeautyServiceCardDimensions(context);

    return Container(
      width: dimensions.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: image,
                  height: dimensions.imageHeight,
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
                    color: Colors.grey[100],
                    child: const Icon(Icons.store),
                  ),
                ),
              ),
              // Favorite Button
              Positioned(
                top: 8,
                right: 8,
                child: BlocBuilder<ToggleFavoritesCubit, ToggleFavoritesState>(
                  builder: (context, state) {
                    final bool isLoading = state is ToggleFavoritesLoading;
                    final bool isFav = state is ToggleFavoritesSuccess
                        ? state.isFavorite
                        : isFavorite;

                    return GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                              if (isFav) {
                                context
                                    .read<ToggleFavoritesCubit>()
                                    .removeFromFavorites(shopId);
                              } else {
                                context
                                    .read<ToggleFavoritesCubit>()
                                    .addToFavorites(shopId);
                              }
                            },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.error,
                                ),
                              )
                            : Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: AppColors.error,
                                size: 18,
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(dimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: getBoldStyle(
                          fontSize: dimensions.titleSize,
                          fontFamily: FontConstant.cairo,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: dimensions.iconSize,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: getBoldStyle(
                            fontSize: dimensions.ratingSize,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '($ratingCount)',
                          style: getMediumStyle(
                            color: AppColors.grey,
                            fontSize: dimensions.ratingSize,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.grey,
                      size: dimensions.iconSize,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: getMediumStyle(
                          color: AppColors.grey,
                          fontSize: dimensions.locationSize,
                          fontFamily: FontConstant.cairo,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Tags
                if (tags != null && tags!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tags!.length,
                      itemBuilder: (context, index) {
                        return _buildTag(tags![index], dimensions);
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, BeautyServiceCardDimensions dimensions) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          label,
          style: getMediumStyle(
            color: AppColors.primary,
            fontSize: dimensions.tagSize,
            fontFamily: FontConstant.cairo,
          ),
        ),
      ),
    );
  }
}
