import 'package:equatable/equatable.dart';
import 'order.dart';

class OrderDetails extends OrderEntity {
  const OrderDetails({
    required super.id,
    required super.description,
    required super.status,
    required super.statusLabel,
    required super.height,
    required super.weight,
    required super.size,
    required super.fabrics,
    required super.executionTime,
    required super.createdAt,
    required super.updatedAt,
    required super.customer,
    required super.images,
    required super.offers,
  });
} 