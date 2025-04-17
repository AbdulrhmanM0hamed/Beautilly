import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Home/presentation/cubit/discounts_cubit/discounts_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/premium_shops_cubit/premium_shops_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/service_cubit/services_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/statistics_cubit/statistics_cubit.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/category_cards.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/services_grid_view.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/special_view_list_view.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/welcome_text_widget.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/popular_salons_list_view.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/fashion_houses_list_view.dart';

import 'package:flutter/material.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/statistics_section.dart';
import '../pages/search_page.dart';
import 'package:beautilly/core/services/service_locator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'location_search_form.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          context.read<ServicesCubit>().loadServices(),
          context.read<StatisticsCubit>().getStatistics(),
          context.read<PremiumShopsCubit>().loadPremiumShops(),
          context.read<DiscountsCubit>().loadDiscounts(),
        ]);
      },
      color: AppColors.primary,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          cacheExtent: 1000,
          slivers: [
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const WelcomeTextWidget(),
                  const SizedBox(height: 16),
                  const LocationSearchForm(),
                  
                  Container(
                    height: 50,
                    margin: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => BlocProvider(
                              create: (context) => sl<SearchCubit>(),
                              child: const SearchPage(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: SvgPicture.asset(
                                  AppAssets.searchIcon,
                                  width: 30,
                                  height: 30,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              Text(
                                ' ابحث عن صالون  او  دار ازياء ...',
                                style: getMediumStyle(
                                  color: AppColors.grey,
                                  fontSize: FontSize.size14,
                                  fontFamily: FontConstant.cairo,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'ابدأ تجربة البحث عن الذى تريده, وسوف نقدم لك ما يناسبك',
                      style: getMediumStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Add Category Cards
                  const CategoryCards(),
                ]),
              ),
            ),
            // const SliverPadding(
            //     padding: EdgeInsets.symmetric(horizontal: 16),
            //     sliver: SliverToBoxAdapter(
            //       child: SpecialViewListView(),
            //     )),
            // const SliverPadding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.0 , vertical: 16),
            //   sliver: SliverToBoxAdapter(child: ServicesGridView(maxItems: 4)),
            // ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16.0),
            ),
            const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(child: PopularSalonsListView())),
            // const SliverPadding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.0),
            //     sliver:
            //          SliverToBoxAdapter(child: FashionHousesListView())),
            // const SliverPadding(
            //   padding: EdgeInsets.only(right: 16.0 , left: 16, bottom:16  , top: 8),
            //   sliver: SliverToBoxAdapter(child: StatisticsSection()),
            // ),
          ],
        ),
      ),
    );
  }
}
