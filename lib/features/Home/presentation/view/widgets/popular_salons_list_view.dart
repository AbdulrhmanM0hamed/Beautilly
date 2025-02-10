import 'package:beautilly/features/salone_profile/presentation/view/salone_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/animations/custom_progress_indcator.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../cubit/premium_shops_cubit/premium_shops_cubit.dart';
import '../../cubit/premium_shops_cubit/premium_shops_state.dart';
import 'shared/beauty_service_card.dart';

class PopularSalonsListView extends StatefulWidget {
  const PopularSalonsListView({super.key});

  @override
  State<PopularSalonsListView> createState() => _PopularSalonsListViewState();
}

class _PopularSalonsListViewState extends State<PopularSalonsListView> {
  @override
  void initState() {
    super.initState();
    context.read<PremiumShopsCubit>().loadPremiumShops();
  }

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
            height: 245,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.shops.length,
              itemBuilder: (context, index) {
                final shop = state.shops[index];
                if (shop.type == 'salon') {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SalonProfileView(salonId: shop.id),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: BeautyServiceCard(
                        image: shop.mainImageUrl,
                        name: shop.name,
                        location: '${shop.cityName}، ${shop.stateName}',
                        rating: shop.avgRating ?? 0.0,
                        ratingCount: shop.loversCount,
                        tags: shop.services.map((e) => e.name).toList(),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
