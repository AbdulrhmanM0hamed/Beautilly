import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/services_grid_view.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/special_view_list_view.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/welcome_text_widget.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/popular_salons_list_view.dart';
import 'package:flutter/material.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            const SpecialtiesView(),
            const SizedBox(height: 16.0),
            Text(
              'ما الذى تريدى ان تفعليه؟',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
              ),
            ),
            const SizedBox(height: 16.0),
            const ServicesGridView(),
            const SizedBox(height: 24.0),
            Text(
              'أشهر صالونات التجميل',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
              ),
            ),
            const SizedBox(height: 16.0),
            const PopularSalonsListView(),
          ],
        ),
      ),
    );
  }
}
