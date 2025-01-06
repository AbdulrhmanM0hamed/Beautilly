import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/models/salon_model.dart';

class AppSalons {
  static const List<SalonModel> popularSalons = [
    SalonModel(
      name: 'Salon de Elegance',
      image: AppAssets.test,
      address: '360 Stillwater Rd. Palm City',
      rating: 4.8,
      reviewCount: 3100,
      services: ['قص شعر', 'أظافر', 'عناية بالبشرة'],
    ),
    SalonModel(
      name: 'Beauty Haven',
      image: AppAssets.test,
      address: '123 Rose St. Garden City',
      rating: 4.6,
      reviewCount: 2800,
      services: ['مكياج', 'قص شعر', 'سبا'],
    ),
    SalonModel(
      name: 'Glamour Studio',
      image: AppAssets.test,
      address: '789 Fashion Ave. Style District',
      rating: 4.9,
      reviewCount: 3500,
      services: ['عناية بالبشرة', 'مكياج', 'إزالة شعر'],
    ),
  ];
}
