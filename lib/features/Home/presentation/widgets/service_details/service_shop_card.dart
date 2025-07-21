import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/navigation/custom_page_route.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Home/domain/entities/service_entity.dart';
import 'package:beautilly/features/salone_profile/presentation/view/salone_profile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/responsive/responsive_card_sizes.dart';

class ServiceShopCard extends StatelessWidget {
  final ServiceShopEntity shop;
  final ServiceDetailsGridDimensions dimensions;

  const ServiceShopCard({
    super.key,
    required this.shop,
    required this.dimensions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
          onTap: () {
            Navigator.push(
              context,
              PageRoutes.fadeScale(
                page: SalonProfileView(salonId: shop.id),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // صورة المتجر مع الطبقات
              Stack(
                children: [
                  // صورة المتجر
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(dimensions.borderRadius),
                    ),
                    child: CachedNetworkImage(
                      height: dimensions.imageHeight,
                      width: double.infinity,
                      imageUrl: shop.mainImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildImagePlaceholder(),
                      errorWidget: (context, url, error) => _buildImageError(),
                    ),
                  ),
                  // تدرج شفاف فوق الصورة
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(dimensions.borderRadius),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // شارة التقييم
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: dimensions.iconSize * 0.9,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            shop.avgRating.toString(),
                            style: getMediumStyle(
                              fontSize: dimensions.ratingSize,
                              fontFamily: FontConstant.cairo,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // السعر
                  if (shop.price != null)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${shop.price} ريال',
                          style: getBoldStyle(
                            fontSize: dimensions.titleSize * 0.9,
                            fontFamily: FontConstant.cairo,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // معلومات المتجر
              Padding(
                padding: EdgeInsets.all(dimensions.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المتجر
                    Text(
                      
                      shop.name,
                      style: getBoldStyle(
                        fontSize: dimensions.titleSize,
                        fontFamily: FontConstant.cairo,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // الموقع
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: dimensions.iconSize,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${shop.cityName}, ${shop.stateName}',
                            style: getRegularStyle(
                              fontSize: dimensions.subtitleSize,
                              fontFamily: FontConstant.cairo,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  Widget _buildImagePlaceholder() => Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      );

  Widget _buildImageError() => Container(
        color: Colors.grey[100],
        child: Icon(
          Icons.error_outline_rounded,
          size: dimensions.iconSize,
          color: Colors.grey[400],
        ),
      );
}
