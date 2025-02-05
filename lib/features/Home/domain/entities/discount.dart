class Discount {
  final int id;
  final String title;
  final String description;
  final String discountType;
  final String discountValue;
  final DateTime validFrom;
  final DateTime validUntil;
  final DiscountShop shop;
  final List<DiscountService> services;

  const Discount({
    required this.id,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.validFrom,
    required this.validUntil,
    required this.shop,
    required this.services,
  });
}

class DiscountShop {
  final int id;
  final String name;
  final String type;
  final String? description;
  final String address;
  final String googleMapsUrl;
  final String mainImageUrl;
  final String mainImageThumb;
  final String mainImageMedium;
  final ShopLocation location;

  const DiscountShop({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.address,
    required this.googleMapsUrl,
    required this.mainImageUrl,
    required this.mainImageThumb,
    required this.mainImageMedium,
    required this.location,
  });
}

class ShopLocation {
  final LocationCity city;
  final LocationState state;

  const ShopLocation({
    required this.city,
    required this.state,
  });
}

class LocationCity {
  final int id;
  final String name;

  const LocationCity({
    required this.id,
    required this.name,
  });
}

class LocationState {
  final int id;
  final String name;

  const LocationState({
    required this.id,
    required this.name,
  });
}

class DiscountService {
  final int id;
  final String name;
  final String type;
  final String description;
  final String price;

  const DiscountService({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
  });
} 