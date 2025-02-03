import '../../domain/entities/favorite_shop.dart';

class FavoriteShopModel extends FavoriteShop {
  const FavoriteShopModel({
    required super.id,
    required super.name,
    required super.type,
    required super.image,
    required super.rating,
    required super.lovesCount,
  });

  factory FavoriteShopModel.fromJson(Map<String, dynamic> json) {
    return FavoriteShopModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      image: json['image'],
      rating: json['rating'],
      lovesCount: json['loves_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'image': image,
      'rating': rating,
      'loves_count': lovesCount,
    };
  }
} 