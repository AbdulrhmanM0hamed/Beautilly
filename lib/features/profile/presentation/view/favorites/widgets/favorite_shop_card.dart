import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/utils/constant/font_manger.dart';
import '../../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../../core/utils/theme/app_colors.dart';
import '../../../../domain/entities/favorite_shop.dart';

class FavoriteShopCard extends StatelessWidget {
  final FavoriteShop shop;

  const FavoriteShopCard({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // التنقل إلى صفحة المتجر
          },
          child: Column(
            children: [
              // صورة المتجر
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: shop.image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              
              // معلومات المتجر
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            shop.name,
                            style: getBoldStyle(
                              fontSize: FontSize.size16,
                              fontFamily: FontConstant.cairo,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildFavoriteButton(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoChip(
                          icon: Icons.star,
                          label: shop.rating,
                          color: const Color.fromARGB(255, 218, 165, 6),
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          icon: Icons.favorite,
                          label: '${shop.lovesCount}',
                          color: AppColors.error,
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          icon: Icons.store,
                          label: shop.type == 'tailor' ? 'دار ازياء' : 'صالون',
                          color: AppColors.primary,
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

  Widget _buildFavoriteButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // تنفيذ إزالة من المفضلة
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.favorite,
            color: AppColors.error,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: getMediumStyle(
              color: color,
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
} 