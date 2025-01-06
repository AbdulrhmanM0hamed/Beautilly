import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MostSearchInterest extends StatelessWidget {
  const MostSearchInterest({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 58,
          child: ListView.builder(
            itemCount: 6,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: MostSearchCard(),
              );
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}


class MostSearchCard extends StatelessWidget {
  const MostSearchCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 135,
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.09),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              'التجميل',
              style: getBoldStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(width: 10.0),
            SvgPicture.asset(
              AppAssets.hairCutIcon,
            )
          ],
        ));
  }
}
