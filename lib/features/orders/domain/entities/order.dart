import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final int id;
  final User user;
  final String description;
  final String status;
  final String statusLabel;
  final int height;
  final int weight;
  final String size;
  final String? executionTime;
  final List<Fabric> fabrics;
  final MainImage mainImage;
  final String createdAt;

  const OrderEntity({
    required this.id,
    required this.user,
    required this.description,
    required this.status,
    required this.statusLabel,
    required this.height,
    required this.weight,
    required this.size,
    this.executionTime,
    required this.fabrics,
    required this.mainImage,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        user,
        description,
        status,
        statusLabel,
        height,
        weight,
        size,
        executionTime,
        fabrics,
        mainImage,
        createdAt,
      ];
}

class User extends Equatable {
  final int id;
  final String name;

  const User({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class Fabric extends Equatable {
  final String type;
  final String color;

  const Fabric({required this.type, required this.color});

  @override
  List<Object?> get props => [type, color];
}

class MainImage extends Equatable {
  final String original;
  final String thumb;
  final String medium;
  final String large;

  const MainImage({
    required this.original,
    required this.thumb,
    required this.medium,
    required this.large,
  });

  @override
  List<Object?> get props => [original, thumb, medium, large];
} 