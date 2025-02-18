import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NearbyServiceCardShimmer extends StatelessWidget {
  const NearbyServiceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Row(
          children: [
            // صورة المتجر
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(12),
                ),
              ),
            ),

            // المحتوى
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // العنوان
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 16,
                          decoration: BoxDecoration(
                            color: baseColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              height: 12,
                              decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // التقييم والمسافة
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 20,
                          decoration: BoxDecoration(
                            color: baseColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),

                    // نوع المتجر
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
