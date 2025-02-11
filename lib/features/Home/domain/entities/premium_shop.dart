import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';

class PremiumShop {
  final int id;
  final String name;
  final String type;
  final int loversCount;
  final String cityName;
  final String stateName;
  final String mainImageUrl;
  final double? avgRating;
  final List<PremiumShopService> services;
  final UserInteraction? userInteraction;

  const PremiumShop({
    required this.id,
    required this.name,
    required this.type,
    required this.loversCount,
    required this.cityName,
    required this.stateName,
    required this.mainImageUrl,
    this.avgRating,
    required this.services,
    this.userInteraction,
  });
}

class PremiumShopService {
  final int id;
  final String name;
  final String price;

  const PremiumShopService({
    required this.id,
    required this.name,
    required this.price,
  });
} 