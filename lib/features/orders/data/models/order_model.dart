import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
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

  const OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      user: User.fromJson(json['user']),
      description: json['description'],
      status: json['status'],
      statusLabel: json['status_label'],
      height: json['height'],
      weight: json['weight'],
      size: json['size'],
      executionTime: json['execution_time'],
      fabrics: (json['fabrics'] as List)
          .map((fabric) => Fabric.fromJson(fabric))
          .toList(),
      mainImage: MainImage.fromJson(json['main_image']),
      createdAt: json['created_at'],
    );
  }

  @override
  List<Object?> get props => [id, user, description, status, statusLabel, height, 
    weight, size, executionTime, fabrics, mainImage, createdAt];
}

class User extends Equatable {
  final int id;
  final String name;

  const User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class Fabric extends Equatable {
  final String type;
  final String color;

  const Fabric({required this.type, required this.color});

  factory Fabric.fromJson(Map<String, dynamic> json) {
    return Fabric(
      type: json['type'],
      color: json['color'],
    );
  }

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

  factory MainImage.fromJson(Map<String, dynamic> json) {
    return MainImage(
      original: json['original'],
      thumb: json['thumb'],
      medium: json['medium'],
      large: json['large'],
    );
  }

  @override
  List<Object?> get props => [original, thumb, medium, large];
} 