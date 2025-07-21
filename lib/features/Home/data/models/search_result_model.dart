import '../../domain/entities/search_result.dart';

class SearchResultModel extends SearchResult {
  const SearchResultModel({
    required super.id,
    required super.name,
    required super.type,
    required super.cityName,
    required super.stateName,
    required super.avgRating,
    required super.loversCount,
    required super.mainShopImageUrl,
    required super.userInteractions,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      cityName: json['city_name'],
      stateName: json['state_name'],
      avgRating: json['avg_rating']?.toDouble() ?? 0.0,
      loversCount: json['lovers_count'] ?? 0,
      mainShopImageUrl: json['main_shop_image_url'] ?? '',
      userInteractions: UserInteractionsModel.fromJson(json['user_interactions']),
    );
  }
}

class UserInteractionsModel extends UserInteractions {
 const  UserInteractionsModel({
    required super.hasLiked,
    required super.hasRated,
    required super.hasCommented,
  });

  factory UserInteractionsModel.fromJson(Map<String, dynamic> json) {
    return UserInteractionsModel(
      hasLiked: json['has_liked'] ?? false,
      hasRated: json['has_rated'] ?? false,
      hasCommented: json['has_commented'] ?? false,
    );
  }
}
