import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';

class OfferCardShimmer extends StatelessWidget {
  const OfferCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getOfferCardDimensions(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: dimensions.height,
      width: dimensions.width,
      margin: const EdgeInsets.only(left: 16),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: dimensions.borderRadius,
              ),
            ),
            // Left cutout circle
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
            // Right cutout circle
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
            // Content shimmer
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
                            Container(
                              height: dimensions.titleSize,
                              width: 150,
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[850] : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: dimensions.descriptionSize,
                              width: 100,
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[850] : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Discount circle shimmer
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[850] : Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                // Button shimmer
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 