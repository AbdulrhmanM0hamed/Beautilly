import '../../domain/entities/discount.dart';

class DiscountModel extends Discount {
  const DiscountModel({
    required super.id,
    required super.title,
    required super.description,
    required super.discountType,
    required super.discountValue,
    required super.validFrom,
    required super.validUntil,
    required super.shop,
    required super.services,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      discountType: json['discount_type'],
      discountValue: json['discount_value'],
      validFrom: DateTime.parse(json['valid_from']),
      validUntil: DateTime.parse(json['valid_until']),
      shop: DiscountShopModel.fromJson(json['shop']),
      services: (json['services'] as List)
          .map((service) => DiscountServiceModel.fromJson(service))
          .toList(),
    );
  }
}

class DiscountShopModel extends DiscountShop {
  const DiscountShopModel({
    required super.id,
    required super.name,
    required super.type,
    super.description,
    required super.address,
    required super.googleMapsUrl,
    required super.mainImageUrl,
    required super.mainImageThumb,
    required super.mainImageMedium,
    required super.location,
  });

  factory DiscountShopModel.fromJson(Map<String, dynamic> json) {
    return DiscountShopModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      address: json['address'],
      googleMapsUrl: json['google_maps_url'] ?? '',
      mainImageUrl: json['main_shop_image_url'] ?? '',
      mainImageThumb: json['main_shop_image_thumb'] ?? '',
      mainImageMedium: json['main_shop_image_medium'] ?? '',
      location: ShopLocationModel.fromJson(json['location']),
    );
  }
}

class ShopLocationModel extends ShopLocation {
  const ShopLocationModel({
    required super.city,
    required super.state,
  });

  factory ShopLocationModel.fromJson(Map<String, dynamic> json) {
    return ShopLocationModel(
      city: LocationCityModel.fromJson(json['city']),
      state: LocationStateModel.fromJson(json['state']),
    );
  }
}

class LocationCityModel extends LocationCity {
  const LocationCityModel({
    required super.id,
    required super.name,
  });

  factory LocationCityModel.fromJson(Map<String, dynamic> json) {
    return LocationCityModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class LocationStateModel extends LocationState {
  const LocationStateModel({
    required super.id,
    required super.name,
  });

  factory LocationStateModel.fromJson(Map<String, dynamic> json) {
    return LocationStateModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class DiscountServiceModel extends DiscountService {
  const DiscountServiceModel({
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    required super.price,
  });

  factory DiscountServiceModel.fromJson(Map<String, dynamic> json) {
    return DiscountServiceModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      price: json['price'],
    );
  }
} 