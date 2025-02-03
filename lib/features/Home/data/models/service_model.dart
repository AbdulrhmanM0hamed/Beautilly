import '../../domain/entities/service.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.name,
    super.description,
    required super.type,
    required super.isActive,
    required super.services,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      isActive: json['is_active'] == 1,
      services: json['services'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'is_active': isActive ? 1 : 0,
      'services': services,
    };
  }
} 