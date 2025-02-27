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


import 'package:flutter_bloc/flutter_bloc.dart';

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'ابدأ تجربة البحث عن الذى تريده, وسوف نقدم لك ما يناسبك',
                    style: getMediumStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 16.0),
                const SpecialViewListView(),
                const SizedBox(height: 16.0),
                const StatisticsSection(),
                const SizedBox(height: 16.0),
                const ServicesGridView(maxItems: 4),
                const SizedBox(height: 16.0),
                const PopularSalonsListView(),
                const FashionHousesListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
