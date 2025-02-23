import '../../domain/entities/discount.dart';

class DiscountModel extends Discount {
  const DiscountModel({
    required super.id,
    required super.title,
    required super.description,
    required super.discountType,
    required super.discountValue,
    required super.validFrom,
    required super.validUntil,
    required super.shop,
    required super.services,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      discountType: json['discount_type'] ?? '',
      discountValue: json['discount_value'] ?? '0',
      validFrom: DateTime.parse(json['valid_from']),
      validUntil: DateTime.parse(json['valid_until']),
      shop: DiscountShopModel.fromJson(json['shop']),
      services: const [],
    );
  }
}

class DiscountShopModel extends DiscountShop {
  const DiscountShopModel({
    required super.id,
    required super.mainImageUrl,
  });

  factory DiscountShopModel.fromJson(Map<String, dynamic> json) {
    return DiscountShopModel(
      id: json['id'],
      mainImageUrl: json['main_shop_image_url'],
    );
  }
}

class DiscountServiceModel extends DiscountService {
  const DiscountServiceModel({
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    required super.price,
  });

  factory DiscountServiceModel.fromJson(Map<String, dynamic> json) {
    try {
     
      
      final service = DiscountServiceModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        type: json['type'] ?? '',
        description: json['description'] ?? '',
        price: json['price']?.toString() ?? '0',
      );
      return service;
    } catch (e, stackTrace) {
   
      rethrow;
    }
  }
}

class DiscountsResponse {
  final List<Discount> discounts;
  final Pagination pagination;

  DiscountsResponse({
    required this.discounts,
    required this.pagination,
  });

  factory DiscountsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    
    return DiscountsResponse(
      discounts: (data['discounts'] as List)
          .map((discount) => DiscountModel.fromJson(discount))
          .toList(),
      pagination: Pagination.fromJson(data['pagination']),
    );
  }
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }
} 