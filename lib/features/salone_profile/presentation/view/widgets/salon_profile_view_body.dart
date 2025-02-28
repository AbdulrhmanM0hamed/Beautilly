import 'package:beautilly/core/utils/common/arrow_back_widget.dart';
import 'package:beautilly/core/utils/common/image_viewer.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_gallery_grid.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_info_card.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_services_section.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_team_section.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_reviews_section.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_discounts_section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/favorites_cubit/toggle_favorites_cubit.dart';
import '../../cubit/favorites_cubit/toggle_favorites_state.dart';
import 'package:beautilly/core/utils/widgets/custom_snackbar.dart';

class SalonProfileViewBody extends StatelessWidget {
  final SalonProfile profile;

  const SalonProfileViewBody({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Salon Image Header
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: Stack(
                children: [
                  // Background Image
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageViewer(
                            imageUrl: profile.images.main,
                          ),
                        ),
                      );
                    },
                    child: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl: profile.images.main,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/salon_image.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Action Buttons
                  Positioned(
                    top: 50,
                    left: 16,
                    child: Row(
                      children: [
                        BlocConsumer<ToggleFavoritesCubit,
                            ToggleFavoritesState>(
                          listener: (context, state) {
                            if (state is ToggleFavoritesError) {
                              CustomSnackbar.showError(
                                context: context,
                                message: state.message,
                              );
                            }
                          },
                          builder: (context, state) {
                            final bool isLoading =
                                state is ToggleFavoritesLoading;
                            final bool isFavorite =
                                state is ToggleFavoritesSuccess
                                    ? state.isFavorite
                                    : profile.userInteraction.hasLiked;

                            return CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: IconButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        if (isFavorite) {
                                          context
                                              .read<ToggleFavoritesCubit>()
                                              .removeFromFavorites(profile.id);
                                        } else {
                                          context
                                              .read<ToggleFavoritesCubit>()
                                              .addToFavorites(profile.id);
                                        }
                                      },
                                icon: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? Colors.red
                                            : AppColors.grey.withOpacity(0.7),
                                      ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        // CircleAvatar(
                        //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        //   child: SvgPicture.asset(
                        //     AppAssets.map,
                        //     color: AppColors.secondary,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              leading: const Padding(
                padding: EdgeInsets.all(8.0),
                child: ArrowBackWidget(),
              ),
            ),

            // Salon Details
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    SalonInfoCard(
                      name: profile.name,
                      description: profile.description ?? '',
                      location: profile.location,
                      workingHours: profile.workingHours,
                    ),
                    SalonDiscountsSection(
                      shopId: profile.id,
                      discounts: profile.discounts,
                    ),
                    SalonServicesSection(
                      shopId: profile.id,
                      services: profile.services,
                    ),
                    SalonGalleryGrid(
                      images: profile.images,
                    ),
                    SalonTeamSection(
                      staff: profile.staff,
                    ),
                    SalonReviewsSection(
                      hasRated: profile.userInteraction.hasRated,
                      salonId: profile.id,
                      ratings: profile.ratings,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
