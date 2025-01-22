import 'package:equatable/equatable.dart';

class ReservationEntity extends Equatable {
  final int id;
  final Shop shop;
  final Service service;
  final double? discount;
  final DateTime startTime;
  final DateTime endTime;
  final String status;

  const ReservationEntity({
    required this.id,
    required this.shop,
    required this.service,
    this.discount,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        shop,
        service,
        discount,
        startTime,
        endTime,
        status,
      ];
}

class Shop extends Equatable {
  final int id;
  final String name;
  final List<String> media;

  const Shop({
    required this.id,
    required this.name,
    required this.media,
  });

  @override
  List<Object?> get props => [id, name, media];
}

class Service extends Equatable {
  final int id;
  final String name;

  const Service({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
} 