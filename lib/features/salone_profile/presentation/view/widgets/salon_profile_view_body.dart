import 'package:beautilly/core/utils/common/arrow_back_widget.dart';
import 'package:beautilly/core/utils/common/custom_button.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_gallery_grid.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_info_card.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_services_section.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/salon_team_section.dart';
import 'package:flutter/material.dart';

class SalonProfileViewBody extends StatelessWidget {
  const SalonProfileViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Salon Image Header
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.asset(
              'assets/images/salon_image.jpg',
              fit: BoxFit.cover,
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                SalonInfoCard(),
                SalonServicesSection(),
                SalonGalleryGrid(),
                SalonTeamSection(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(text: "احجزى الان"),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
