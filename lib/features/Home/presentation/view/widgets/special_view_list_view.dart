import 'package:beautilly/core/utils/shimmer/special_view_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../../../../core/utils/theme/app_colors.dart';
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
          return const SpecialViewShimmer();
        }

        if (state is DiscountsLoaded) {
          return SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.discounts.length,
              itemBuilder: (context, index) => OfferCard(
                discount: state.discounts[index],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
