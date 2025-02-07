import 'package:beautilly/features/orders/domain/entities/order.dart';

import '../../domain/entities/order_details.dart';
import 'order_model.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.city,
    required super.state,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      city: json['city'],
      state: json['state'],
    );
  }
}

class UserWithDetailsModel extends UserWithDetails {
  const UserWithDetailsModel({
    required super.id,
    required super.name,
    required super.images,
    required super.address,
  });

  factory UserWithDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserWithDetailsModel(
      id: json['id'],
      name: json['name'],
      images: ImagesModel.fromJson(json['images']),
      address: AddressModel.fromJson(json['address']),
    );
  }
}

class ShopWithDetailsModel extends ShopWithDetails {
  const ShopWithDetailsModel({
    required super.id,
    required super.name,
    required super.images,
    required super.address,
  });

  factory ShopWithDetailsModel.fromJson(Map<String, dynamic> json) {
    return ShopWithDetailsModel(
      id: json['id'],
      name: json['name'],
      images: ImagesModel.fromJson(json['images']),
      address: AddressModel.fromJson(json['address']),
    );
  }
}

class OfferWithDetailsModel extends OfferWithDetails {
  const OfferWithDetailsModel({
    required super.id,
    required super.price,
    super.notes,
    required super.status,
    required super.createdAt,
    required super.shop,
  });

  factory OfferWithDetailsModel.fromJson(Map<String, dynamic> json) {
    return OfferWithDetailsModel(
      id: json['id'],
      price: json['price']?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      shop: ShopWithDetailsModel.fromJson(json['shop']),
    );
  }
}

class OrderDetailsModel extends OrderDetails {
  const OrderDetailsModel({
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

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      id: json['id'],
      description: json['description'],
      status: json['status'],
      statusLabel: json['status_label'],
      height: json['height'],
      weight: json['weight'],
      size: json['size'],
      fabrics: (json['fabrics'] as List)
          .map((fabric) => FabricModel.fromJson(fabric))
          .toList(),
      executionTime: json['execution_time'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      customer: UserWithDetailsModel.fromJson(json['customer']),
      images: ImagesModel.fromJson(json['images']),
      offers: (json['offers'] as List?)
              ?.map<OfferWithDetailsModel>((offer) =>
                  OfferWithDetailsModel.fromJson(offer as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class OfferModel extends Offer {
  const OfferModel({
    required super.id,
    required super.price,
    super.notes,
    required super.status,
    required super.createdAt,
    required super.shop,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'],
      price: json['price']?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      shop: ShopModel.fromJson(json['shop'] as Map<String, dynamic>),
    );
  }
}

class ImagesModel extends MainImage {
  const ImagesModel({
    required super.main,
    required super.thumb,
    required super.medium,
    required super.large,
  });

  factory ImagesModel.fromJson(Map<String, dynamic> json) {
    return ImagesModel(
      main: json['main'] ?? '',
      thumb: json['thumb'] ?? '',
      medium: json['medium'] ?? '',
      large: json['large'] ?? '',
    );
  }
}
