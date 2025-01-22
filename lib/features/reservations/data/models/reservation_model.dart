import '../../domain/entities/reservation.dart';

class ReservationModel extends ReservationEntity {
  const ReservationModel({
    required super.id,
    required super.shop,
    required super.service,
    super.discount,
    required super.startTime,
    required super.endTime,
    required super.status,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      shop: ShopModel.fromJson(json['shop']),
      service: ServiceModel.fromJson(json['service']),
      discount: json['discount'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      status: json['status'],
    );
  }
}

class ShopModel extends Shop {
  const ShopModel({
    required super.id,
    required super.name,
    required super.media,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'],
      name: json['name'],
      media: List<String>.from(json['media'] ?? []),
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