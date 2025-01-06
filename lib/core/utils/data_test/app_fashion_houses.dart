import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/models/fashion_house_model.dart';

class AppFashionHouses {
  static const List<FashionHouseModel> fashionHouses = [
    FashionHouseModel(
      name: 'روز للأزياء الراقية',
      image: AppAssets.test2,
      specialties: ['فساتين سهرة', 'عبايات', 'فساتين زفاف'],
      location: 'شارع التحلية، جدة',
      rating: 4.9,
      reviewCount: 2800,
      isVerified: true,
      tags: ['تفصيل راقي', 'تصميم خاص', 'خياطة احترافية'],
    ),
    FashionHouseModel(
      name: 'لمسات الأناقة',
      image: AppAssets.test2,
      specialties: ['ملابس محجبات', 'بدل رسمية', 'عبايات خليجية'],
      location: 'شارع الملك فهد، الرياض',
      rating: 4.8,
      reviewCount: 1950,
      isVerified: true,
      tags: ['تطريز يدوي', 'أقمشة فاخرة', 'تصاميم عصرية'],
    ),
    FashionHouseModel(
      name: 'دار الخياطة الملكية',
      image: AppAssets.test2,
      specialties: ['فساتين ملكية', 'عبايات مطرزة', 'تصميم خاص'],
      location: 'شارع الشيخ زايد، دبي',
      rating: 4.7,
      reviewCount: 3200,
      isVerified: true,
      tags: ['تفصيل VIP', 'أقمشة مستوردة', 'تطريز فاخر'],
    ),
  ];
}
