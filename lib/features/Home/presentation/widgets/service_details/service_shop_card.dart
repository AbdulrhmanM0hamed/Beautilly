import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Home/domain/entities/service_entity.dart';
import 'package:beautilly/features/salone_profile/presentation/view/salone_profile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ServiceShopCard extends StatelessWidget {
  final ServiceShopEntity shop;

  const ServiceShopCard({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SalonProfileView(salonId: shop.id)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: CachedNetworkImage(
                  imageUrl: shop.mainImageUrl,
                  fit: BoxFit.cover,
                  //placeholder: (context, url) => const ShimmerLoader(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop Name
                  Text(
                    shop.name,
                    style: getBoldStyle(
                      fontSize: FontSize.size16,
                      fontFamily: FontConstant.cairo,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${shop.cityName}، ${shop.stateName}',
                          style: getRegularStyle(
                            fontSize: FontSize.size12,
                            fontFamily: FontConstant.cairo,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Rating & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${shop.avgRating ?? 0}',
                            style: getMediumStyle(
                              fontSize: FontSize.size12,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                          Text(
                            ' (${shop.loversCount})',
                            style: getRegularStyle(
                              fontSize: FontSize.size12,
                              fontFamily: FontConstant.cairo,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      // Price
                      Text(
                        '${shop.price} ريال',
                        style: getBoldStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
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
