import 'package:beautilly/features/orders/domain/entities/order.dart';

import '../../domain/entities/order_details.dart';
import 'order_model.dart';

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
    try {
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
        customer: UserModel.fromJson(json['customer'] as Map<String, dynamic>),
        images: ImagesModel.fromJson(json['images'] as Map<String, dynamic>),
        offers: (json['offers'] as List?)
                ?.map<OfferModel>((offer) =>
                    OfferModel.fromJson(offer as Map<String, dynamic>))
                .toList() ??
            [],
      );
    } catch (e) {
      print('Error parsing OrderDetailsModel: $e');
      print('JSON data: $json');
      rethrow;
    }
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
