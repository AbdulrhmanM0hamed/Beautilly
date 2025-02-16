import 'package:beautilly/core/utils/animations/custom_progress_indcator.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/search_shops_cubit.dart';
import '../../cubit/search_shops_state.dart';
import 'nearby_service_card.dart';

class DiscoverBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final Function(double latitude, double longitude)? onLocationSelect;

  const DiscoverBottomSheet({
    super.key,
    required this.scrollController,
    this.onLocationSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'الأقرب إليك',
                  style: getBoldStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // List of Nearby Services
          Expanded(
            child: BlocBuilder<SearchShopsCubit, SearchShopsState>(
              builder: (context, state) {
                if (state is SearchShopsLoading) {
                  return const Center(
                    child: CustomProgressIndcator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (state is SearchShopsError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: getMediumStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                  );
                }

                if (state is SearchShopsLoaded) {
                  if (state.shops.isEmpty) {
                    return Center(
                      child: Text(
                        'لا توجد نتائج',
                        style: getMediumStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.shops.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: NearbyServiceCard(
                          shop: state.shops[index],
                          onLocationTap: onLocationSelect,
                        ),
                      );
                    },
                  );
                }

                return const Center(
                  child: Text(
                    'ابحث عن صالون أو دار أزياء',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
