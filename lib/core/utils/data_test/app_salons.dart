import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/models/salon_model.dart';

class AppSalons {
  static const List<SalonModel> popularSalons = [
    SalonModel(
      name: 'صالون الأناقة',
      image: AppAssets.test,
      address: '360 شارع ستيلووتر، مدينة النخيل',
      rating: 4.8,
      reviewCount: 3100,
      services: ['قص شعر', 'أظافر', 'عناية بالبشرة'],
    ),
    SalonModel(
      name: 'جنة الجمال',
      image: AppAssets.test,
      address: '123 شارع الورد، مدينة الحديقة',
      rating: 4.6,
      reviewCount: 2800,
      services: ['مكياج', 'قص شعر', 'سبا'],
    ),
    SalonModel(
      name: 'استوديو الجمال',
      image: AppAssets.test,
      address: '789 شارع الموضة، حي الأناقة',
      rating: 4.9,
      reviewCount: 3500,
      services: ['عناية بالبشرة', 'مكياج', 'إزالة شعر'],
    ),
  ];
}
