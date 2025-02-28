import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';

class ServiceCardShimmer extends StatelessWidget {
  const ServiceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getServiceGridDimensions(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة الخدمة مع الـ chips
            AspectRatio(
              aspectRatio: 1.8,
              child: Stack(
                children: [
                  // الصورة الرئيسية
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(dimensions.borderRadius),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: isDark ? Colors.grey[850] : Colors.white,
                    ),
                  ),
                  // نوع الخدمة chip
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color:
                                  isDark ? Colors.grey[700] : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 30,
                            height: 12,
                            decoration: BoxDecoration(
                              color:
                                  isDark ? Colors.grey[700] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // عدد المتاجر chip
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color:
                                  isDark ? Colors.grey[700] : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 40,
                            height: 12,
                            decoration: BoxDecoration(
                              color:
                                  isDark ? Colors.grey[700] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // اسم الخدمة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 100,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Grid للـ Shimmer
class ServicesGridShimmer extends StatelessWidget {
  const ServicesGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getServiceGridDimensions(context);

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: dimensions.crossAxisCount,
        childAspectRatio: dimensions.childAspectRatio,
        crossAxisSpacing: dimensions.spacing,
        mainAxisSpacing: dimensions.spacing,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => const ServiceCardShimmer(),
    );
  }
}

class AllServicesGridShimmer extends StatelessWidget {
  const AllServicesGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getServiceGridDimensions(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: dimensions.crossAxisCount,
          childAspectRatio: dimensions.childAspectRatio,
          crossAxisSpacing: dimensions.spacing,
          mainAxisSpacing: dimensions.spacing,
        ),
        itemCount: 30,
        itemBuilder: (context, index) => const ServiceCardShimmer(),
      ),
    );
  }
}

// Shimmer للـ BeautyServiceCard
class BeautyServiceCardShimmer extends StatelessWidget {
  const BeautyServiceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dimensions =
        ResponsiveCardSizes.getBeautyServiceCardDimensions(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: dimensions.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    height: dimensions.imageHeight,
                    width: double.infinity,
                    color: isDark ? Colors.grey[850] : Colors.white,
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[700] : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(dimensions.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Rating
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: dimensions.titleSize,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Container(
                            width: dimensions.iconSize,
                            height: dimensions.iconSize,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[850] : Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 30,
                            height: dimensions.ratingSize,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[850] : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      Container(
                        width: dimensions.iconSize,
                        height: dimensions.iconSize,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[850] : Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: dimensions.locationSize,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Tags
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: index < 2 ? 8 : 0, // لا padding للعنصر الأخير
                        ),
                        child: Container(
                          width: 60,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shimmer للقوائم الأفقية
class BeautyServiceListShimmer extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;

  const BeautyServiceListShimmer({
    super.key,
    this.isDesktop = false,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isDesktop
          ? 320
          : isTablet
              ? 280
              : 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsetsDirectional.only(
              end: isDesktop
                  ? 24
                  : isTablet
                      ? 20
                      : 16,
            ),
            child: const BeautyServiceCardShimmer(),
          );
        },
      ),
    );
  }
}
