import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/Discover/presentation/view/widgets/nearby_service_card.dart';
import 'package:flutter/material.dart';

class DiscoverBottomSheet extends StatelessWidget {
  const DiscoverBottomSheet({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'الأقرب إليك',
                  style: getBoldStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Show filter options
                  },
                  child: Text(
                    'تصفية',
                    style: getMediumStyle(
                      color: AppColors.primary,
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // List of Nearby Services
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: NearbyServiceCard(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
