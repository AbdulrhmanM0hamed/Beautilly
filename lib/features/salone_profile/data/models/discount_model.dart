import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';

class DiscountModel extends Discount {
  const DiscountModel({
    required super.id,
    required super.title,
    required super.description,
    required super.discountType,
    required super.discountValue,
    required super.pricing,
    required super.validFrom,
    required super.validUntil,
    required super.isActive,
    required super.isValid,
    required super.services,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      discountType: json['discount_type'],
      discountValue: json['discount_value'],
      pricing: DiscountPricingModel.fromJson(json['pricing']),
      validFrom: DateTime.parse(json['valid_from']),
      validUntil: DateTime.parse(json['valid_until']),
      isActive: json['is_active'] == 1,
      isValid: json['is_valid'],
      services: (json['services'] as List)
          .map((service) => DiscountServiceModel.fromJson(service))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'pricing': pricing.toJson(),
      'valid_from': validFrom.toIso8601String(),
      'valid_until': validUntil.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'is_valid': isValid,
      'services': services.map((service) => service.toJson()).toList(),
    };
  }
}

class DiscountPricingModel extends DiscountPricing {
  const DiscountPricingModel({
    required super.originalPrice,
    required super.discountType,
    required super.discountValue,
    required super.finalPrice,
    required super.discountAmount,
    required super.savingsPercentage,
  });

  factory DiscountPricingModel.fromJson(Map<String, dynamic> json) {
    return DiscountPricingModel(
      originalPrice: json['original_price'],
      discountType: json['discount_type'],
      discountValue: json['discount_value'],
      finalPrice: json['final_price'],
      discountAmount: json['discount_amount'],
      savingsPercentage: json['savings_percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original_price': originalPrice,
      'discount_type': discountType,
      'discount_value': discountValue,
      'final_price': finalPrice,
      'discount_amount': discountAmount,
      'savings_percentage': savingsPercentage,
    };
  }
}

class DiscountServiceModel extends DiscountService {
  const DiscountServiceModel({
    required super.id,
    required super.name,
    required super.price,
  });

  factory DiscountServiceModel.fromJson(Map<String, dynamic> json) {
    return DiscountServiceModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
} 