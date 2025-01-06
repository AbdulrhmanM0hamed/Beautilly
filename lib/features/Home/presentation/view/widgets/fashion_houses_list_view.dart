import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FashionHousesListView extends StatelessWidget {
  const FashionHousesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: FashionHouseCard(),
          );
        },
      ),
    );
  }
}


class FashionHouseCard extends StatelessWidget {
  const FashionHouseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  AppAssets.test2,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Favorite Button
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: AppColors.error,
                    size: 18,
                  ),
                ),
              ),

            ],
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'روز للأزياء الراقية',
                        style: getBoldStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '4.9',
                          style: getBoldStyle(
                            fontSize: FontSize.size12,
                            fontFamily: FontConstant.cairo,
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
                    const Icon(
                      Icons.location_on,
                      color: AppColors.grey,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'شارع التحلية، جدة',
                      style: getMediumStyle(
                        color: AppColors.grey,
                        fontSize: FontSize.size12,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Tags
                SizedBox(
                  height: 24,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildTag('تفصيل راقي'),
                      _buildTag('تصميم خاص'),
                      _buildTag('خياطة احترافية'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTag(String label) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: getMediumStyle(
          color: AppColors.secondary,
          fontSize: FontSize.size10,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }
}
