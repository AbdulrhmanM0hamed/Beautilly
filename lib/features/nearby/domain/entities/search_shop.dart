class SearchShop {
  final int id;
  final String name;
  final String type;
  final String typeName;
  final double rating;
  final Location location;
  final MainImage mainImage;
  final double? latitude;
  final double? longitude;
  final City city;
  final State state;

  const SearchShop({
    required this.id,
    required this.name,
    required this.type,
    required this.typeName,
    required this.rating,
    required this.location,
    required this.mainImage,
    required this.city,
    required this.state,
    this.latitude,
    this.longitude,
  });
}

class Location {
  final String? mapUrl;
  final double? latitude;
  final double? longitude;

  const Location({
    this.mapUrl,
    this.latitude,
    this.longitude,
  });
}

class MainImage {
  final String original;
  final String thumb;
  final String medium;

  const MainImage({
    required this.original,
    required this.thumb,
    required this.medium,
  });
}

class ShopService {
  final int id;
  final String name;
  final String description;
  final String type;
  final String price;

  const ShopService({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
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

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class City {
  final int id;
  final String name;

  const City({
    required this.id,
    required this.name,
  });
}

class State {
  final int id;
  final String name;

  const State({
    required this.id,
    required this.name,
  });
} 