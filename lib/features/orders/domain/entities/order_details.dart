import 'order.dart';

class Address {
  final String city;
  final String state;

  const Address({
    required this.city,
    required this.state,
  });
}

class UserWithDetails extends User {
  final MainImage images;
  final Address address;
  

  const UserWithDetails({
    required super.id,
    required super.name,
    required this.images,
    required this.address,
  });
}

class ShopWithDetails extends Shop {
  final MainImage images;
  final Address address;

  const ShopWithDetails({
    required super.id,
    required super.name,
    required this.images,
    required this.address,
  });
}

class OrderDetails {
  final int id;
  final String description;
  final String status;
  final String statusLabel;
  final int height;
  final int weight;
  final String size;
  final List<Fabric> fabrics;
  final int executionTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserWithDetails customer;
  final MainImage images;
  final List<OfferWithDetails> offers;

  const OrderDetails({
    required this.id,
    required this.description,
    required this.status,
    required this.statusLabel,
    required this.height,
    required this.weight,
    required this.size,
    required this.fabrics,
    required this.executionTime,
    required this.createdAt,
    required this.updatedAt,
    required this.customer,
    required this.images,
    required this.offers,
  });
}

class OfferWithDetails extends Offer {
  final int? daysCount;

  const OfferWithDetails({
    required super.id,
    required super.price,
    super.notes,
    this.daysCount,
    required super.status,
    required super.createdAt,
    required ShopWithDetails shop,
  }) : super(shop: shop);
} 