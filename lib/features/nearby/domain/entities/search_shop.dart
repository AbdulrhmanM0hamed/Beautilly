class SearchShop {
  final int id;
  final String name;
  final String type;
  final String cityName;
  final String stateName;
  final double avgRating;
  final int loversCount;
  final String mainImageUrl;
  final List<ShopService> services;
  final UserInteraction userInteraction;

  const SearchShop({
    required this.id,
    required this.name,
    required this.type,
    required this.cityName,
    required this.stateName,
    required this.avgRating,
    required this.loversCount,
    required this.mainImageUrl,
    required this.services,
    required this.userInteraction,
  });
}

class ShopService {
  final int id;
  final String name;
  final String price;

  const ShopService({
    required this.id,
    required this.name,
    required this.price,
  });
}

class UserInteraction {
  final bool hasLiked;
  final bool hasRated;
  final bool hasCommented;

  const UserInteraction({
    required this.hasLiked,
    required this.hasRated,
    required this.hasCommented,
  });
} 