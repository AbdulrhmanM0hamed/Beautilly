import 'package:beautilly/core/utils/data_test/app_salons.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/shared/beauty_service_card.dart';
import 'package:flutter/material.dart';

class PopularSalonsListView extends StatelessWidget {
  const PopularSalonsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 245,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppSalons.popularSalons.length,
        itemBuilder: (context, index) {
          final salon = AppSalons.popularSalons[index];
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: BeautyServiceCard(
              ratingCount: salon.reviewCount,
              image: salon.image,
              name: salon.name,
              location: salon.address,
              rating: salon.rating,
              tags: salon.services,
            ),
          );
        },
      ),
    );
  }
}
