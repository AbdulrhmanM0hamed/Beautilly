import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../cubit/premium_shops_cubit/premium_shops_cubit.dart';
import '../../cubit/premium_shops_cubit/premium_shops_state.dart';
import 'shared/beauty_service_card.dart';

class FashionHousesListView extends StatelessWidget {
  const FashionHousesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PremiumShopsCubit, PremiumShopsState>(
      builder: (context, state) {
        if (state is PremiumShopsLoading) {
          return const Center(
            child: CustomProgressIndcator(
              color: AppColors.primary,
            ),
          );
        }

        if (state is PremiumShopsError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is PremiumShopsLoaded) {
          return SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.shops.length,
              itemBuilder: (context, index) {
                final shop = state.shops[index];
                // نعرض فقط المحلات التي نوعها خياط
                if (shop.type == 'tailor') {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: BeautyServiceCard(
                      image: shop.mainImageUrl,
                      name: shop.name,
                      location: '${shop.cityName}، ${shop.stateName}',
                      rating: shop.avgRating ?? 0.0,
                      ratingCount: shop.loversCount,
                      tags: shop.services.map((e) => e.name).toList(),
                    ),
                  );
                }
                return const SizedBox.shrink(); // نخفي المحلات الأخرى
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
