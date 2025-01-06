import 'package:beautilly/core/utils/data_test/app_fashion_houses.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/shared/beauty_service_card.dart';
import 'package:flutter/material.dart';

class FashionHousesListView extends StatelessWidget {
  const FashionHousesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppFashionHouses.fashionHouses.length,
        itemBuilder: (context, index) {
          final fashionHouse = AppFashionHouses.fashionHouses[index];
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: BeautyServiceCard(
              image: fashionHouse.image,
              name: fashionHouse.name,
              location: fashionHouse.location,
              rating: fashionHouse.rating,
              ratingCount: fashionHouse.reviewCount,
              tags: fashionHouse.tags,
            ),
          );
        },
      ),
    );
  }
}
