import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/custom_material_button.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/discount_number.dart';
import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardHeight = size.height * 0.18; // 18% of screen height
    final cutoutSize = size.width * 0.075; // 7.5% of screen width
    
    return Container(
      height: cardHeight,
      width: size.width * 0.85, // 90% of screen width
      
      child: Stack(
        children: [
          // Main Card
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(AppAssets.test),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // Left side circular cutout
          Positioned(
            left: -cutoutSize / 2,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: cutoutSize,
                height: cutoutSize,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // Right side circular cutout
          Positioned(
            right: -cutoutSize / 2,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: cutoutSize,
                height: cutoutSize,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Right side content (Title)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: size.width * 0.06),
                      child: Text(
                        ' كوني أكثر جمالاً \nمع خصومات أكبر',
                        style: getSemiBoldStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.04, // 4% of screen width
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ),
                  ),
                  // Discount circle
                  const DiscountNumber(discount: 20),
                ],
              ),
              // Button at the bottom
              const CustomMaterialButton(),
            ],
          ),
        ],
      ),
    );
  }
}
