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
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      discountType: json['discount_type'] ?? '',
      discountValue: json['discount_value'] ?? 0,
      pricing: DiscountPricingModel.fromJson(json['pricing']),
      validFrom: DateTime.parse(json['valid_from'] ?? ''),
      validUntil: DateTime.parse(json['valid_until'] ?? ''),
      isActive: json['is_active'] == 1,
      isValid: json['is_valid'] ?? false,
      services: (json['services'] as List)
          .map((service) => DiscountServiceModel.fromJson(service))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? ''  ,
      'title': title ?? '',
      'description': description ?? '',
      'discount_type': discountType ?? '',
      'discount_value': discountValue ?? 0,
      'pricing': pricing.toJson() ?? {},
      'valid_from': validFrom.toIso8601String() ?? '',
      'valid_until': validUntil.toIso8601String() ?? '',
      'is_active': isActive ? 1 : 0,
      'is_valid': isValid ?? false,
      'services': services.map((service) => service.toJson()).toList(),
    };
  }
}

class DiscountPricingModel extends DiscountPricing {
  const DiscountPricingModel({
    required super.originalPrice ,
    required super.discountType,
    required super.discountValue,
    required super.finalPrice,
    required super.discountAmount,
    required super.savingsPercentage,
  });

  factory DiscountPricingModel.fromJson(Map<String, dynamic> json) {
    return DiscountPricingModel(
      originalPrice: json['original_price'] ?? 0,
      discountType: json['discount_type'] ?? '',
      discountValue: json['discount_value'] ?? 0,
      finalPrice: json['final_price'] ?? 0,
      discountAmount: json['discount_amount'] ?? 0,
      savingsPercentage: json['savings_percentage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original_price': originalPrice ?? 0,
      'discount_type': discountType ?? '',
      'discount_value': discountValue ?? 0,
      'final_price': finalPrice ?? 0,
      'discount_amount': discountAmount ?? 0,
      'savings_percentage': savingsPercentage ?? 0,
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
        id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'name': name ?? '',
      'price': price ?? 0,
    };
  }
} 