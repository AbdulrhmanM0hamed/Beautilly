import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/custom_material_button.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/discount_number.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/discount.dart';

class OfferCard extends StatelessWidget {
  final Discount discount;

  const OfferCard({
    super.key,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardHeight = size.height * 0.18;
    final cutoutSize = size.width * 0.075;
    
    return Container(
      height: cardHeight,
      width: size.width * 0.85,
      margin: const EdgeInsets.only(left: 16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(discount.shop.mainImageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: size.width * 0.06 , top: size.height * 0.019),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            discount.title,
                            style: getBoldStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.05,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            discount.description,
                            style: getMediumStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: size.width * 0.03,
                              fontFamily: FontConstant.cairo,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  DiscountNumber(
                    discount: double.parse(discount.discountValue).toInt(),
                  ),
                ],
              ),
              const CustomMaterialButton(),
            ],
          ),
        ],
      ),
    );
  }
}
