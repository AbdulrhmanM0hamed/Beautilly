import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/service_card.dart';
import 'package:flutter/material.dart';

class SalonServicesSection extends StatelessWidget {
  const SalonServicesSection({super.key});

  static final List<ServiceModel> services = [
    ServiceModel(
      name: 'قص شعر لوب',
      duration: '1.5 ساعة',
      image: AppAssets.test,
      price: 55,
      discount: 69,
    ),
    ServiceModel(
      name: 'صبغة شعر',
      duration: 'ساعتين',
      image: AppAssets.test,
      price: 120,
      discount: 150,
    ),
    ServiceModel(
      name: 'تنظيف بشرة',
      duration: 'ساعة',
      image: AppAssets.test,
      price: 80,
    ),
    ServiceModel(
      name: 'مكياج سهرة',
      duration: 'ساعة ونصف',
      image: AppAssets.test,
      price: 200,
      discount: 250,
    ),
  ];

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
              Text(
                'الخدمات',
                style: getBoldStyle(
                  fontSize: FontSize.size20,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              TextButton(
                onPressed: () {},
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
              return ServiceCard(service: services[index]);
            },
          ),
        ],
      ),
    );
  }
}
