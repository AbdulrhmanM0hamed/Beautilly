import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final int id;
  final String description;
  final String status;
  final String statusLabel;
  final int height;
  final int weight;
  final String size;
  final List<Fabric> fabrics;
  final int? executionTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User customer;
  final MainImage images;
  final List<Offer> offers;

  const OrderEntity({
    required this.id,
    required this.description,
    required this.status,
    required this.statusLabel,
    required this.height,
    required this.weight,
    required this.size,
    required this.fabrics,
    this.executionTime,
    required this.createdAt,
    required this.updatedAt,
    required this.customer,
    required this.images,
    required this.offers,
  });

  @override
  List<Object?> get props => [
        id, description, status, statusLabel,
        height, weight, size, fabrics,
        executionTime, createdAt, updatedAt,
        customer, images, offers,
      ];
}

class User extends Equatable {
  final int id;
  final String name;
  final String? avatar;

  const User({
    required this.id,
    required this.name,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, name, avatar];
}

class Fabric extends Equatable {
  final String type;
  final String color;

  const Fabric({required this.type, required this.color});

  @override
  List<Object?> get props => [type, color];
}

class MainImage extends Equatable {
  final String main;
  final String thumb;
  final String medium;
  final String large;

  const MainImage({
    required this.main,
    required this.thumb,
    required this.medium,
    required this.large,
  });

  @override
  List<Object?> get props => [main, thumb, medium, large];
}

class Offer extends Equatable {
  final int id;
  final double price;
  final String? notes;
  final String status;
  final DateTime createdAt;
  final Shop shop;

  const Offer({
    required this.id,
    required this.price,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.shop,
  });

  @override
  List<Object?> get props => [id, price, notes, status, createdAt, shop];
}

class Shop extends Equatable {
  final int id;
  final String name;

  const Shop({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
} 