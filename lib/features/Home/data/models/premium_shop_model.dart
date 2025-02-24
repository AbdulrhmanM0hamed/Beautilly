import 'package:beautilly/features/salone_profile/data/models/salon_profile_model.dart';

import '../../domain/entities/premium_shop.dart';

class PremiumShopModel extends PremiumShop {
  const PremiumShopModel({
    required super.id,
    required super.name,
    required super.type,
    required super.loversCount,
    required super.cityName,
    required super.stateName,
    required super.mainImageUrl,
    super.avgRating,
    required super.services,
    super.userInteraction,
  });

  factory PremiumShopModel.fromJson(Map<String, dynamic> json) {
    return PremiumShopModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      loversCount: json['lovers_count'] ?? 0,
      cityName: json['city_name'] ?? '',
      stateName: json['state_name'] ?? '',
      mainImageUrl: json['main_shop_image_url'] ?? '',
      avgRating: json['avg_rating']?.toDouble()?? '',
      services: (json['services'] as List)
          .map((service) => PremiumShopServiceModel.fromJson(service) )
          .toList() ,
      userInteraction: json['user_interactions'] != null 
          ? UserInteractionModel.fromJson(json['user_interactions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? ''  ,
      'name': name ?? '',
      'type': type ?? '',
      'lovers_count': loversCount ?? '',
      'city_name': cityName ?? '',
      'state_name': stateName ?? '',
      'main_shop_image_url': mainImageUrl ?? '',
      'avg_rating': avgRating ?? '',
      'services': services
          .map((service) => (service as PremiumShopServiceModel).toJson())
          .toList(),
    };
  }
}

class PremiumShopServiceModel extends PremiumShopService {
  const PremiumShopServiceModel({
    required super.id,
    required super.name,
    required super.price,
  });

  factory PremiumShopServiceModel.fromJson(Map<String, dynamic> json) {
    return PremiumShopServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'name': name ?? '',
      'price': price ?? '',
    };
  }
}
