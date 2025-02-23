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
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    context.read<DiscountsCubit>().loadDiscounts();
    _setupScrollController();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.7) {
        _loadMoreDiscounts();
      }
    });
  }

  Future<void> _loadMoreDiscounts() async {
    final state = context.read<DiscountsCubit>().state;
    if (state is DiscountsLoaded && !_isLoadingMore && !state.isLastPage) {
      setState(() => _isLoadingMore = true);
      await context.read<DiscountsCubit>().loadMoreDiscounts();
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscountsCubit, DiscountsState>(
      builder: (context, state) {
        if (state is DiscountsLoading && !_isLoadingMore) {
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
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: state.discounts.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < state.discounts.length) {
                  return OfferCard(discount: state.discounts[index]);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: OfferCardShimmer(),
                  );
                }
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
