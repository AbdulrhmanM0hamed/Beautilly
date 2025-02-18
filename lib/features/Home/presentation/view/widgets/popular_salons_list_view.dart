import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/features/salone_profile/presentation/cubit/favorites_cubit/toggle_favorites_cubit.dart';
import 'package:beautilly/features/salone_profile/presentation/view/salone_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/premium_shops_cubit/premium_shops_cubit.dart';
import '../../cubit/premium_shops_cubit/premium_shops_state.dart';
import 'shared/beauty_service_card.dart';
import '../../../../../core/utils/responsive/app_responsive.dart';
import '../../../../../core/utils/shimmer/service_card_shimmer.dart';

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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= AppResponsive.mobileBreakpoint;
    final isDesktop = size.width >= AppResponsive.tabletBreakpoint;

    return BlocBuilder<PremiumShopsCubit, PremiumShopsState>(
      builder: (context, state) {
        if (state is PremiumShopsLoading) {
          return BeautyServiceListShimmer(
            isDesktop: size.width >= AppResponsive.tabletBreakpoint,
            isTablet: size.width >= AppResponsive.mobileBreakpoint,
          );
        }

        if (state is PremiumShopsError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is PremiumShopsLoaded) {
          return SizedBox(
            height: isDesktop
                ? 330
                : isTablet
                    ? 290
                    : 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.shops.length,
              itemBuilder: (context, index) {
                final shop = state.shops[index];
                if (shop.type == 'salon') {
                  return BlocProvider(
                    create: (context) => sl<ToggleFavoritesCubit>(),
                    child: GestureDetector(
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
                        padding: EdgeInsetsDirectional.only(
                          end: isDesktop
                              ? 24
                              : isTablet
                                  ? 16
                                  : 16,
                        ),
                        child: BeautyServiceCard(
                          image: shop.mainImageUrl,
                          name: shop.name,
                          location: '${shop.cityName}، ${shop.stateName}',
                          rating: shop.avgRating ?? 0.0,
                          ratingCount: shop.loversCount,
                          tags: shop.services.map((e) => e.name).toList(),
                          shopId: shop.id,
                          isFavorite: shop.userInteraction?.hasLiked ?? false,
                        ),
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
