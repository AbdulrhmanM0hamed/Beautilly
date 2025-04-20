import 'package:beautilly/core/services/service_locator.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/nearby/domain/entities/shop_type.dart';
import 'package:beautilly/features/nearby/presentation/cubit/search_shops_cubit.dart';
import 'package:beautilly/features/nearby/presentation/view/widgets/discover_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCards extends StatelessWidget {
  const CategoryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            'بحث',
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildCategoryCard(
                context,
                'صالونات التجميل',
                'assets/images/salon.png',
                ShopType.salon,
              ),
            ),
            Expanded(
              child: _buildCategoryCard(
                context,
                'تفصيل الأزياء',
                'assets/images/tailor.png',
                ShopType.tailor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String imagePath,
    ShopType shopType,
  ) {
    return GestureDetector(
      onTap: () {
        // Show the bottom sheet with a new instance of SearchShopsCubit
        _showDiscoverBottomSheet(context, shopType);
      },
      child: Container(
        height: 160,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image with overlay
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.primary.withOpacity(0.1),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              // Title at the bottom
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.size16,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDiscoverBottomSheet(BuildContext context, ShopType shopType) {
    final ScrollController scrollController = ScrollController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider(
          create: (context) => sl<SearchShopsCubit>()
            ..changeType(shopType)
            ..filterShops(),
          child: DiscoverBottomSheet(
            scrollController: scrollController,
          ),
        );
      },
    );
  }
}
