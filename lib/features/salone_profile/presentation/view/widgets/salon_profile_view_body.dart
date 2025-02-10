import 'package:beautilly/core/utils/common/arrow_back_widget.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_gallery_grid.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_info_card.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_services_section.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_team_section.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_reviews_section.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/booking_bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
              flexibleSpace: FlexibleSpaceBar(
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
                    const SizedBox(height: 16),
                    SalonInfoCard(
                      name: profile.name,
                      description: profile.description ?? '',
                      location: profile.location,
                      workingHours: profile.workingHours,
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
                    SalonReviewsSection(),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BookingBottomBar(
            servicesCount: profile.services.length,
            total: profile.services.fold<double>(
              0, 
              (sum, service) => sum + (double.tryParse(service.price) ?? 0)
            ),
          ),
        ),
      ],
    );
  }
}
