import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String type;
  final CategoryEntity category;
  final String image;
  final List<ShopEntity> shops;

  const ServiceEntity({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.category,
    required this.image,
    required this.shops,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        category,
        image,
        shops,
      ];
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

  const ShopEntity({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, price];
} 