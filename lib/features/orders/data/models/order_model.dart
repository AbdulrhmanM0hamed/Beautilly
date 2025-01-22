import '../../domain/entities/order.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.user,
    required super.description,
    required super.status,
    required super.statusLabel,
    required super.height,
    required super.weight,
    required super.size,
    super.executionTime,
    required super.fabrics,
    required super.mainImage,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      description: json['description'],
      status: json['status'],
      statusLabel: json['status_label'],
      height: json['height'],
      weight: json['weight'],
      size: json['size'],
      executionTime: json['execution_time'],
      fabrics: (json['fabrics'] as List)
          .map((fabric) => FabricModel.fromJson(fabric))
          .toList(),
      mainImage: MainImageModel.fromJson(json['main_image']),
      createdAt: json['created_at'],
    );
  }
}

class UserModel extends User {
  const UserModel({required super.id, required super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class FabricModel extends Fabric {
  const FabricModel({required super.type, required super.color});

  factory FabricModel.fromJson(Map<String, dynamic> json) {
    return FabricModel(
      type: json['type'],
      color: json['color'],
    );
  }
}

class MainImageModel extends MainImage {
  const MainImageModel({
    required super.original,
    required super.thumb,
    required super.medium,
    required super.large,
  });

  factory MainImageModel.fromJson(Map<String, dynamic> json) {
    return MainImageModel(
      original: json['original'],
      thumb: json['thumb'],
      medium: json['medium'],
      large: json['large'],
    );
  }
} 