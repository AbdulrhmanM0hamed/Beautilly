import '../../domain/entities/salon_profile.dart';

class DiscountModel extends Discount {
  const DiscountModel({
    required super.id,
    required super.title,
    required super.description,
    required super.discountType,
    required super.discountValue,
    required super.validUntil,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      discountType: json['discount_type'],
      discountValue: json['discount_value'],
      validUntil: DateTime.parse(json['valid_until']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'valid_until': validUntil.toIso8601String(),
    };
  }
} 