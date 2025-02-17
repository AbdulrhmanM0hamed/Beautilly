import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Home/presentation/cubit/discounts_cubit/discounts_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/premium_shops_cubit/premium_shops_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/service_cubit/services_cubit.dart';
import 'package:beautilly/features/Home/presentation/cubit/statistics_cubit/statistics_cubit.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/services_grid_view.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/special_view_list_view.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/welcome_text_widget.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/popular_salons_list_view.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/fashion_houses_list_view.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/statistics_section.dart';
import 'package:beautilly/core/utils/navigation/custom_page_route.dart';
import 'package:beautilly/features/Home/presentation/view/all_services_view.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          context.read<ServicesCubit>().getServices(),
          context.read<StatisticsCubit>().getStatistics(),
          context.read<PremiumShopsCubit>().loadPremiumShops(),
          context.read<DiscountsCubit>().loadDiscounts(),
        ]);
      },
      color: AppColors.primary,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WelcomeTextWidget(),
                const SizedBox(height: 4.0),
                Text(
                  'ابدأ تجربة البحث عن الذى تريده, وسوف نقدم لك ما يناسبك',
                  style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16.0),
                const SpecialViewListView(),
                const SizedBox(height: 16.0),
                const StatisticsSection(),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ما الذي تريدين أن تفعليه؟',
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // التنقل إلى صفحة كل الخدمات
                        Navigator.of(context).push(
                          PageRoutes.fadeScale(
                            page: const AllServicesView(),
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
                const ServicesGridView(maxItems: 4),
                const SizedBox(height: 22.0),
                Text(
                  'أشهر صالونات التجميل',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                  ),
                ),
                const SizedBox(height: 16.0),
                const PopularSalonsListView(),
                // Text(
                //   'الأكثر بحثاً',
                //   style: getBoldStyle(
                //     fontFamily: FontConstant.cairo,
                //     fontSize: FontSize.size16,
                //   ),
                // ),
                // const SizedBox(height: 16.0),
                //   const MostSearchInterest(),
                //   const SizedBox(height: 20.0),
                Text(
                  'دور الأزياء والتفصيل',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                  ),
                ),
                const SizedBox(height: 16.0),
                const FashionHousesListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
