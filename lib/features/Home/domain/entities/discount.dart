class Discount {
  final int id;
  final String title;
  final String description;
  final String discountType;
  final String discountValue;
  final DateTime validFrom;
  final DateTime validUntil;
  final DiscountShop shop;
  final List<DiscountService> services;

  const Discount({
    required this.id,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.validFrom,
    required this.validUntil,
    required this.shop,
    required this.services,
  });
}

class DiscountShop {
  final int id;
  final String mainImageUrl;

  const DiscountShop({
    required this.id,
    required this.mainImageUrl,
  });
}

class DiscountService {
  final int id;
  final String name;
  final String type;
  final String description;
  final String price;

  const DiscountService({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
  });
} 