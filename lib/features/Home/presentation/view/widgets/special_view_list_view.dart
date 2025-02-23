import 'package:beautilly/core/utils/shimmer/offer_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/discounts_cubit/discounts_cubit.dart';
import '../../cubit/discounts_cubit/discounts_state.dart';
import 'offer_card.dart';

class SpecialViewListView extends StatefulWidget {
  const SpecialViewListView({super.key});

  @override
  State<SpecialViewListView> createState() => _SpecialViewListViewState();
}

class _SpecialViewListViewState extends State<SpecialViewListView> {
  @override
  void initState() {
    super.initState();
    context.read<DiscountsCubit>().loadDiscounts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscountsCubit, DiscountsState>(
      builder: (context, state) {
        if (state is DiscountsLoading) {
          return SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) => const OfferCardShimmer(),
            ),
          );
        }

        if (state is DiscountsLoaded) {
          return SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.discounts.length,
              itemBuilder: (context, index) {
                print('🎴 Building offer card for index: $index');
                return OfferCard(
                  discount: state.discounts[index],
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
