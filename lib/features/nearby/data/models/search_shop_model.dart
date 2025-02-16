import '../../domain/entities/search_shop.dart';

class SearchShopModel extends SearchShop {
  const SearchShopModel({
    required super.id,
    required super.name,
    required super.type,
    required super.typeName,
    required super.rating,
    required super.location,
    required super.mainImage,
    super.latitude,
    super.longitude,
  });

  factory SearchShopModel.fromJson(Map<String, dynamic> json) {
    return SearchShopModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      typeName: json['type_name'],
      rating: (json['rating'] ?? 0).toDouble(),
      location: LocationModel.fromJson(json['location']),
      mainImage: MainImageModel.fromJson(json['main_image']),
      latitude: json['location']?['latitude']?.toDouble(),
      longitude: json['location']?['longitude']?.toDouble(),
    );
  }
}

class LocationModel extends Location {
  const LocationModel({
    super.mapUrl,
    super.latitude,
    super.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      mapUrl: json['map_url'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}

class MainImageModel extends MainImage {
  const MainImageModel({
    required super.original,
    required super.thumb,
    required super.medium,
  });

  factory MainImageModel.fromJson(Map<String, dynamic> json) {
    return MainImageModel(
      original: json['original'],
      thumb: json['thumb'],
      medium: json['medium'],
    );
  }
}

class ShopServiceModel extends ShopService {
  const ShopServiceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.type,
    required super.price,
  });

  factory ShopServiceModel.fromJson(Map<String, dynamic> json) {
    return ShopServiceModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      price: json['price']?.toString() ?? '0',
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
