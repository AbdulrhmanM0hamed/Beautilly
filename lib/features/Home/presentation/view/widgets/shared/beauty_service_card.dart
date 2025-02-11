import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Home/presentation/cubit/premium_shops_cubit/premium_shops_cubit.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/favorites_cubit/toggle_favorites_cubit.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/favorites_cubit/toggle_favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Container(
      width: 220,
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
                  height: 140,
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
                    final bool isFav = state is ToggleFavoritesSuccess ? 
                                       state.isFavorite : 
                                       isFavorite;

                    return GestureDetector(
                      onTap: isLoading ? null : () {
                        if (isFav) {
                          context.read<ToggleFavoritesCubit>().removeFromFavorites(shopId);
                        } else {
                          context.read<ToggleFavoritesCubit>().addToFavorites(shopId);
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
            padding: const EdgeInsets.all(12),
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
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: getBoldStyle(
                            fontSize: FontSize.size12,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '($ratingCount)',
                          style: getMediumStyle(
                            color: AppColors.grey,
                            fontSize: FontSize.size12,
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
                    const Icon(
                      Icons.location_on,
                      color: AppColors.grey,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: getMediumStyle(
                          color: AppColors.grey,
                          fontSize: FontSize.size12,
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
                    height: 24,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tags!.length,
                      itemBuilder: (context, index) {
                        return _buildTag(tags![index]);
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

  Widget _buildTag(String label) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: getMediumStyle(
          color: AppColors.primary,
          fontSize: FontSize.size10,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }
}
