import 'package:beautilly/core/utils/constant/app_assets.dart';
import 'package:beautilly/core/utils/models/service_item_model.dart';

class AppServices {
  static final List<ServiceItem> mainServices = [
    ServiceItem(
      icon: AppAssets.hairCutIcon,
      title: 'قص شعر',
    ),
    ServiceItem(
      icon: AppAssets.nailsIcon,
      title: 'أظافر',
    ),
    ServiceItem(
      icon: AppAssets.facialIcon,
      title: 'عناية بالبشرة',
    ),
    ServiceItem(
      icon: AppAssets.coloringIcon,
      title: 'صبغات',
    ),
    ServiceItem(
      icon: AppAssets.spaIcon,
      title: 'سبا',
    ),
    ServiceItem(
      icon: AppAssets.waxingIcon,
      title: 'إزالة شعر',
    ),
    ServiceItem(
      icon: AppAssets.makeupIcon,
      title: 'مكياج',
    ),
    ServiceItem(
      icon: AppAssets.dressVector,
      title: 'تصميم ازياء',
    ),
  ];
}
