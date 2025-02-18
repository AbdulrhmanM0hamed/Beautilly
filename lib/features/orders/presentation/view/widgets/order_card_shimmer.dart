import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';
import 'package:beautilly/features/reservations/presentation/view/widgets/shimmer_effect.dart';

class OrderCardShimmer extends StatelessWidget {
  const OrderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dimensions = ResponsiveCardSizes.getOrderCardDimensions(context);

    return Container(
      width: dimensions.width,
      height: dimensions.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: dimensions.borderRadius,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Image Shimmer
          ShimmerEffect(
            height: dimensions.height * 0.4,
            width: double.infinity,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(dimensions.borderRadius),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(dimensions.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description Shimmer
                  const ShimmerEffect(
                    height: 16,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 8),
                  const ShimmerEffect(
                    height: 16,
                    width: 200,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Measurements Shimmer
                  Row(
                    children: List.generate(3, (index) => 
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: dimensions.spacing / 2,
                          ),
                          child: const ShimmerEffect(
                            height: 24,
                            width: 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Fabrics Shimmer
                  Row(
                    children: List.generate(2, (index) => 
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: dimensions.spacing / 2,
                          ),
                          child: const ShimmerEffect(
                            height: 24,
                            width: 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 