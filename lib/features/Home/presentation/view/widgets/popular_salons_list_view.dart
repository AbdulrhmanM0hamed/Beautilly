import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/navigation/custom_page_route.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Home/presentation/view/all_premium_salons_view.dart';
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
          return const SizedBox.shrink();
        }

        if (state is PremiumShopsLoaded) {
          final salons = state.shops.where((shop) => shop.type == 'salon').toList();
          
          if (salons.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'أشهر صالونات التجميل',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRoutes.fadeScale(
                          page: const AllPremiumSalonsView(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'عرض المزيد',
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: isDesktop ? 300 : isTablet ? 280 : 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: salons.length,
                  itemBuilder: (context, index) {
                    final shop = salons[index];
                    return BlocProvider(
                      create: (context) => sl<ToggleFavoritesCubit>(),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SalonProfileView(salonId: shop.id),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                            end: isDesktop ? 24 : 16,
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
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
