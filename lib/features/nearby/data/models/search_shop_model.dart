import '../../domain/entities/search_shop.dart';

class SearchShopModel extends SearchShop {
  const SearchShopModel({
    required super.id,
    required super.name,
    required super.type,
    required super.cityName,
    required super.stateName,
    required super.avgRating,
    required super.loversCount,
    required super.mainImageUrl,
    required super.services,
    required super.userInteraction,
  });

  factory SearchShopModel.fromJson(Map<String, dynamic> json) {
    return SearchShopModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      cityName: json['city_name'],
      stateName: json['state_name'],
      avgRating: (json['avg_rating'] ?? 0).toDouble(),
      loversCount: json['lovers_count'] ?? 0,
      mainImageUrl: json['main_shop_image_url'],
      services: (json['services'] as List)
          .map((service) => ShopServiceModel.fromJson(service))
          .toList(),
      userInteraction: UserInteractionModel.fromJson(json['user_interactions']),
    );
  }
}

class ShopServiceModel extends ShopService {
  const ShopServiceModel({
    required super.id,
    required super.name,
    required super.price,
  });

  factory ShopServiceModel.fromJson(Map<String, dynamic> json) {
    return ShopServiceModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }
}

class UserInteractionModel extends UserInteraction {
  const UserInteractionModel({
    required super.hasLiked,
    required super.hasRated,
    required super.hasCommented,
  });

  factory UserInteractionModel.fromJson(Map<String, dynamic> json) {
    return UserInteractionModel(
      hasLiked: json['has_liked'] ?? false,
      hasRated: json['has_rated'] ?? false,
      hasCommented: json['has_commented'] ?? false,
    );
  }
} 