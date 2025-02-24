import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final int id;
  final String name;
  final String type;
  final String description;
  final String image;
  final List<ServiceShopEntity> shops;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.image,
    required this.shops,
  });

  @override
  List<Object?> get props => [id, name, type, description, image, shops];
}

class ServiceShopEntity extends Equatable {
  final int id;
  final String name;
  final String cityName;
  final String stateName;
  final String mainImageUrl;
  final double? avgRating;
  final int loversCount;
  final String price;



  const ServiceShopEntity({
    required this.id,
    required this.name,
    required this.cityName,
    required this.stateName,
    required this.mainImageUrl,
    required this.avgRating,
    required this.loversCount,
    required this.price,

  });

  @override
  List<Object?> get props => [id, name, cityName, stateName, mainImageUrl];
}

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        createdAt,
        updatedAt,
        isActive,
      ];
}

class ShopEntity extends Equatable {
  final int id;
  final String name;
  final String price;
  final int loversCount;
  final String cityName;
  final String stateName;
  final String mainImageUrl;
  final double? avgRating;
  final List<ServicePivot> services;

  const ShopEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.loversCount,
    required this.cityName,
    required this.stateName,
    required this.mainImageUrl,
    this.avgRating,
    required this.services,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        loversCount,
        cityName,
        stateName,
        mainImageUrl,
        avgRating,
        services,
      ];
}

class ServicePivot extends Equatable {
  final int id;
  final String name;
  final String price;

  const ServicePivot({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, price];
} 