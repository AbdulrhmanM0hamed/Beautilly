import '../../domain/entities/reservation.dart';

class ReservationModel extends ReservationEntity {
  const ReservationModel({
    required super.id,
    required super.shop,
    super.service,
    super.discount,
    required super.date,
    required super.time,
    required super.status,
    super.price,
    required super.type,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      shop: ShopModel.fromJson(json['shop']),
      service: json['service'] != null 
          ? ServiceModel.fromJson(json['service'])
          : null,
      discount: json['discount'] != null 
          ? DiscountModel.fromJson(json['discount'])
          : null,
      date: json['date'],
      time: TimeModelImpl.fromJson(json['time']),
      status: json['status'],
      price: json['price'],
      type: json['type'],
    );
  }
}

class ShopModel extends Shop {
  const ShopModel({
    required super.id,
    required super.name,
    required super.image,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class ServiceModel extends Service {
  const ServiceModel({
    required super.id,
    required super.name,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class DiscountModel extends Discount {
  const DiscountModel({
    required super.id,
    required super.title,
    super.originalPrice,
    required super.discountValue,
    required super.discountType,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'],
      title: json['title'],
      originalPrice: json['original_price'],
      discountValue: json['discount_value'],
      discountType: json['discount_type'],
    );
  }
}

class TimeModelImpl extends TimeModel {
  const TimeModelImpl({
    required super.formatted,
    required super.raw,
  });

  factory TimeModelImpl.fromJson(Map<String, dynamic> json) {
    return TimeModelImpl(
      formatted: json['formatted'],
      raw: json['raw'],
    );
  }
} 