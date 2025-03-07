import '../../domain/entities/order.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
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
      updatedAt: DateTime.parse(json['updated_at'] ?? json['created_at']),
      customer: UserModel.fromJson(json['user']),
      images: ImagesModel.fromJson(json['main_image']),
      offers: (json['offers'] as List?)?.map((offer) => OfferModel.fromJson(offer)).toList() ?? [],
    );
  }
}

class UserModel extends User {
  const UserModel({required super.id, required super.name , required super.avatar});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}

class FabricModel extends Fabric {
  const FabricModel({required super.type, required super.color});

  factory FabricModel.fromJson(Map<String, dynamic> json) {
    return FabricModel(
      type: json['type'],
      color: json['color'],
    );
  }
}

class ImagesModel extends MainImage {
  const ImagesModel({
    required super.main,
    super.thumb = '',
    super.medium = '',
    super.large = '',
  });

  factory ImagesModel.fromJson(Map<String, dynamic> json) {
    return ImagesModel(
      main: json['original'] ?? '',
      thumb: json['thumb'] ?? '',
      medium: json['medium'] ?? '',
      large: json['large'] ?? '',
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
      price: json['price']?.toDouble(),
      notes: json['notes'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      shop: ShopModel.fromJson(json['shop']),
    );
  }
}

class ShopModel extends Shop {
  const ShopModel({required super.id, required super.name});

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class OrdersResponseModel extends OrdersResponse {
  const OrdersResponseModel({
    required super.orders,
    required super.pagination,
  });

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return OrdersResponseModel(
      orders: (json['data'] as List)
          .map((order) => OrderModel.fromJson(order))
          .toList(),
      pagination: OrderPaginationModel.fromJson(json['pagination']),
    );
  }
}

class OrderPaginationModel extends OrderPagination {
  const OrderPaginationModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory OrderPaginationModel.fromJson(Map<String, dynamic> json) {
    return OrderPaginationModel(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }
}