import 'package:equatable/equatable.dart';

class SearchResult extends Equatable {
  final int id;
  final String name;
  final String type;
  final String cityName;
  final String stateName;
  final double avgRating;
  final int loversCount;
  final String mainShopImageUrl;
  final UserInteractions userInteractions;

  const SearchResult({
    required this.id,
    required this.name,
    required this.type,
    required this.cityName,
    required this.stateName,
    required this.avgRating,
    required this.loversCount,
    required this.mainShopImageUrl,
    required this.userInteractions,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        cityName,
        stateName,
        avgRating,
        loversCount,
        mainShopImageUrl,
        userInteractions,
      ];
}

class UserInteractions extends Equatable {
  final bool hasLiked;
  final bool hasRated;
  final bool hasCommented;

  const UserInteractions({
    required this.hasLiked,
    required this.hasRated,
    required this.hasCommented,
  });

  @override
  List<Object?> get props => [hasLiked, hasRated, hasCommented];
}
