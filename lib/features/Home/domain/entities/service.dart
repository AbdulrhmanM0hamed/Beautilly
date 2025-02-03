import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String type;
  final bool isActive;
  final List<dynamic> services;

  const ServiceEntity({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.isActive,
    required this.services,
  });

  @override
  List<Object?> get props => [id, name, description, type, isActive, services];
} 