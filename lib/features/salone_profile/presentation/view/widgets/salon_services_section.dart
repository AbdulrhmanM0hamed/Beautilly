import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/outline_with_icon.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/service_card.dart';
import 'package:flutter/material.dart';

class SalonServicesSection extends StatelessWidget {
  final List<Service> services;
  final int shopId;

  const SalonServicesSection({
    super.key,
    required this.services,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const OutlineWithIcon(
                icon: Icons.spa_outlined,
                title: 'الخدمات',
              ),
              if (services.length > 4)
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all services
                  },
                  child: Text(
                    'عرض المزيد',
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length > 4 ? 4 : services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ServiceCard(
                  service: service,
                  shopId: shopId,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
