import 'package:beautilly/core/utils/data_test/app_salons.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/models/salon_model.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PopularSalonsListView extends StatelessWidget {
  const PopularSalonsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppSalons.popularSalons.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SalonCard(salon: AppSalons.popularSalons[index]),
          );
        },
      ),
    );
  }
}

class SalonCard extends StatelessWidget {
  final SalonModel salon;

  const SalonCard({
    super.key,
    required this.salon,
  });

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
          // Image and Favorite Button
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  salon.image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
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
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Services
                Text(
                  salon.services.join(' . '),
                  style: getRegularStyle(
                    color: AppColors.primary,
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const SizedBox(height: 4),

                // Salon Name
                Text(
                  salon.name,
                  style: getSemiBoldStyle(
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const SizedBox(height: 4),

                // Address
                Text(
                  salon.address,
                  style: getMediumStyle(
                    color: AppColors.textSecondary,
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const SizedBox(height: 8),

                // Rating
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      salon.rating.toString(),
                      style: getBoldStyle(
                        color: AppColors.textSecondary,
                        fontSize: FontSize.size12,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${salon.reviewCount})',
                      style: getSemiBoldStyle(
                        color: AppColors.textSecondary,
                        fontSize: FontSize.size12,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
