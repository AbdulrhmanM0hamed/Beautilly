import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/navigation/custom_page_route.dart';
import 'package:beautilly/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/favorites_cubit/toggle_favorites_cubit.dart';
import 'package:beautilly/features/salone_profile/presentation/view/salone_profile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/favorites_cubit/toggle_favorites_state.dart';
import 'package:beautilly/features/Home/domain/entities/premium_shop.dart';
import 'package:beautilly/core/utils/responsive/app_responsive.dart';

class PremiumSalonGridCard extends StatelessWidget {
  final PremiumShop salon;
  final int index;

  const PremiumSalonGridCard({
    super.key,
    required this.salon,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= AppResponsive.mobileBreakpoint;
    final isDesktop = size.width >= AppResponsive.tabletBreakpoint;
    final bool isGuest = context.read<ProfileCubit>().isGuestUser;
    
    // تعديل الارتفاع للموبايل
    final double height = index % 3 == 0
        ? (isDesktop
            ? 280
            : isTablet
                ? 260
                : 180) // تصغير ارتفاع الكارت الكبير للموبايل
        : (isDesktop
            ? 220
            : isTablet
                ? 200
                : 150); // تصغير ارتفاع الكارت الصغير للموبايل

    return BlocProvider(
      create: (context) => sl<ToggleFavoritesCubit>(),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRoutes.fadeScale(
              page: SalonProfileView(salonId: salon.id),
            ),
          );
        },
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // صورة الخلفية
                CachedNetworkImage(
                  imageUrl: salon.mainImageUrl,
                  fit: BoxFit.cover,
                ),

                // تدرج شفاف للنص
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha:0.7),
                      ],
                    ),
                  ),
                ),

                // المحتوى
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        maxLines: 1,
                        salon.name,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${salon.cityName}، ${salon.stateName}',
                              style: getMediumStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size14,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha:0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${salon.avgRating ?? 0.0}',
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: FontSize.size14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isGuest)
                  // زر المفضلة
                  Positioned(
                    top: 8,
                    right: 8,
                    child:
                        BlocBuilder<ToggleFavoritesCubit, ToggleFavoritesState>(
                      builder: (context, state) {
                        final bool isLoading = state is ToggleFavoritesLoading;
                        final bool isFav = state is ToggleFavoritesSuccess
                            ? state.isFavorite
                            : salon.userInteraction?.hasLiked ?? false;

                        return GestureDetector(
                          onTap: isLoading
                              ? null
                              : () {
                                  if (isFav) {
                                    context
                                        .read<ToggleFavoritesCubit>()
                                        .removeFromFavorites(salon.id);
                                  } else {
                                    context
                                        .read<ToggleFavoritesCubit>()
                                        .addToFavorites(salon.id);
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
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
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
          ),
        ),
      ),
    );
  }
}
