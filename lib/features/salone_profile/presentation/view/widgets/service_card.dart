import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // Service Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: service.image,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/salon_image.jpg',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Service Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: getBoldStyle(
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                if (service.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    service.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: getMediumStyle(
                      color: AppColors.grey,
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${double.parse(service.price).toStringAsFixed(0)} ر.س',
                      style: getBoldStyle(
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.primary,
                      ),
                    ),
                    // Add Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'إضافة',
                        style: getMediumStyle(
                          color: AppColors.white,
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                        ),
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

class ServiceModel {
  final String name;
  final String duration;
  final String image;
  final double price;
  final double? discount;

  ServiceModel({
    required this.name,
    required this.duration,
    required this.image,
    required this.price,
    this.discount,
  });
}
