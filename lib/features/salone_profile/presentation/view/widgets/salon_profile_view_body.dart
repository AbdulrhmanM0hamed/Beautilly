import 'package:beautilly/core/utils/common/arrow_back_widget.dart';
import 'package:beautilly/core/utils/common/image_viewer.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_gallery_grid.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_info_card.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_services_section.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_team_section.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_reviews_section.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/booking_bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_discounts_section.dart';

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
              flexibleSpace: GestureDetector(
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
                      discounts: profile.discounts,
                    ),
                    SalonServicesSection(
                      services: profile.services,
                    ),
                    SalonGalleryGrid(
                      images: profile.images,
                    ),
                    SalonTeamSection(
                      staff: profile.staff,
                    ),
                    SalonReviewsSection(
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
