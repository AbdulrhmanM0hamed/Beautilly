import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../domain/entities/search_shop.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NearbyServiceCard extends StatelessWidget {
  final SearchShop shop;

  const NearbyServiceCard({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: shop.mainImageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Positioned(
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.Location,
                        colorFilter: const ColorFilter.mode(
                          AppColors.accent,
                          BlendMode.srcIn,
                        ),
                        width: 12,
                        height: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '1.2 كم',
                        style: getBoldStyle(
                          color: AppColors.accent,
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          style: getBoldStyle(
                            fontSize: FontSize.size14,
                            fontFamily: FontConstant.cairo,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.Star,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFFB800),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        shop.avgRating.toStringAsFixed(1),
                        style: getBoldStyle(
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${shop.loversCount})',
                        style: getMediumStyle(
                          color: AppColors.grey,
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 35,
                        width: 35,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SvgPicture.asset(
                          AppAssets.direction,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (shop.services.isNotEmpty)
                    SizedBox(
                      height: 24,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: shop.services.length.clamp(0, 2),
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              shop.services[index].name,
                              style: getMediumStyle(
                                color: AppColors.primary,
                                fontSize: FontSize.size10,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),
                          );
                        },
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
