import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/navigation/custom_page_route.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/custom_material_button.dart';
import 'package:beautilly/features/Home/presentation/view/widgets/discount_number.dart';
import 'package:beautilly/features/salone_profile/presentation/view/salone_profile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/discount.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';

class OfferCard extends StatelessWidget {
  final Discount discount;

  const OfferCard({
    super.key,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getOfferCardDimensions(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRoutes.fadeScale(
            page: SalonProfileView(
              salonId: discount.shop.id,
            ),
          ),
        );
      },
      child: Container(
        height: dimensions.height,
        width: dimensions.width,
        margin: const EdgeInsets.only(left: 16),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(discount.shop.mainImageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha:0.4),
                    BlendMode.darken,
                  ),
                ),
                borderRadius: dimensions.borderRadius,
              ),
            ),
            Positioned(
              left: -dimensions.cutoutSize / 2,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: dimensions.cutoutSize,
                  height: dimensions.cutoutSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              right: -dimensions.cutoutSize / 2,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: dimensions.cutoutSize,
                  height: dimensions.cutoutSize,
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
                        padding: EdgeInsets.only(
                          right: dimensions.horizontalPadding,
                          top: dimensions.verticalPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              discount.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: dimensions.titleSize,
                                fontWeight: FontWeight.bold,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              discount.description,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha:0.8),
                                fontSize: dimensions.descriptionSize,
                                fontWeight: FontWeight.w500,
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
                      value: discount.discountValue,
                      type: discount.discountType,
                    ),
                  ],
                ),
                CustomMaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRoutes.fadeScale(
                        page: SalonProfileView(
                          salonId: discount.shop.id,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
