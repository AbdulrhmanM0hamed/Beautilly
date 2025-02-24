import '../../domain/entities/service_entity.dart';

class ServicesResponse {
  final List<ServiceEntity> services;
  final PaginationServiceModel pagination;

  ServicesResponse({
    required this.services,
    required this.pagination,
  });

  factory ServicesResponse.fromJson(Map<String, dynamic> json) {
    return ServicesResponse(
      services: (json['data'] as List)
          .map((service) => ServiceModel.fromJson(service))
          .toList(),
      pagination: PaginationServiceModel.fromJson(json['pagination']),
    );
  }
}

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    required super.image,
    required super.shops,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      shops: (json['shops'] as List)
          .map((shop) => ServiceShopModel.fromJson(shop))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'image': image,
      'shops':
          shops.map((shop) => (shop as ServiceShopModel).toJson()).toList(),
    };
  }
}

class ServiceShopModel extends ServiceShopEntity {
  const ServiceShopModel({
    required super.id,
    required super.name,
    required super.cityName,
    required super.stateName,
    required super.mainImageUrl,
    required super.avgRating,
    required super.loversCount,
    required super.price,
  });

  factory ServiceShopModel.fromJson(Map<String, dynamic> json) {
    return ServiceShopModel(
      id: json['id'],
      name: json['name'],
      cityName: json['city_name'],
      stateName: json['state_name'],
      mainImageUrl: json['main_shop_image_url'],
      avgRating: json['avg_rating']?.toDouble(),
      loversCount: json['lovers_count'] ?? 0,
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city_name': cityName,
      'state_name': stateName,
      'main_shop_image_url': mainImageUrl,
    };
  }
}

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    super.description,
    required super.type,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }
}

class ShopModel extends ShopEntity {
  const ShopModel({
    required super.id,
    required super.name,
    required super.price,
    required super.loversCount,
    required super.cityName,
    required super.stateName,
    required super.mainImageUrl,
    super.avgRating,
    required super.services,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      loversCount: json['lovers_count'] ?? 0,
      cityName: json['city_name'] ?? '',
      stateName: json['state_name'] ?? '',
      mainImageUrl: json['main_shop_image_url'] ?? '',
      avgRating: json['avg_rating']?.toDouble(),
      services: json['services'] != null
          ? (json['services'] as List)
              .map((service) => ServicePivotModel.fromJson(service))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'lovers_count': loversCount,
      'city_name': cityName,
      'state_name': stateName,
      'main_shop_image_url': mainImageUrl,
      'avg_rating': avgRating,
      'services': services
          .map((service) => (service as ServicePivotModel).toJson())
          .toList(),
    };
  }
}

class ServicePivotModel extends ServicePivot {
  const ServicePivotModel({
    required super.id,
    required super.name,
    required super.price,
  });

  factory ServicePivotModel.fromJson(Map<String, dynamic> json) {
    return ServicePivotModel(
      id: json['id'],
      name: json['name'],
      price: json['pivot']['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}

class PaginationServiceModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationServiceModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationServiceModel.fromJson(Map<String, dynamic> json) {
    return PaginationServiceModel(
      currentPage: json['current'] ?? 1,
      lastPage: json['pages'] ?? 1,
      perPage: json['limit'] ?? 10,
      total: json['count'] ?? 0,
    );
  }
}
