import 'package:beautilly/features/Home/presentation/view/widgets/offer_card.dart';
import 'package:flutter/material.dart';

class SpecialtiesView extends StatelessWidget {
  const SpecialtiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: OfferCard(),
              );
            },
            itemCount: 5));
  }
}
