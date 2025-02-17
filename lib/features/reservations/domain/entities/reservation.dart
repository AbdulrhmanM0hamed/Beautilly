
class ReservationEntity {
  final int id;
  final Shop shop;
  final Service? service;
  final Discount? discount;
  final String date;
  final TimeModel time;
  final String status;
  final String? price;
  final String type;

  const ReservationEntity({
    required this.id,
    required this.shop,
    this.service,
    this.discount,
    required this.date,
    required this.time,
    required this.status,
    this.price,
    required this.type,
  });

  DateTime get startTime => DateTime.parse('$date ${time.raw}');
  
  DateTime get endTime {
    final start = DateTime.parse('$date ${time.raw}');
    return start.add(const Duration(hours: 1));
  }
}

class Shop {
  final int id;
  final String name;
  final String image;

  const Shop({
    required this.id,
    required this.name,
    required this.image,
  });
}

class Service {
  final int id;
  final String name;

  const Service({
    required this.id,
    required this.name,
  });
}

class Discount {
  final int id;
  final String title;
  final String? originalPrice;
  final String discountValue;
  final String discountType;

  const Discount({
    required this.id,
    required this.title,
    this.originalPrice,
    required this.discountValue,
    required this.discountType,
  });
}

class TimeModel {
  final String formatted;
  final String raw;

  const TimeModel({
    required this.formatted,
    required this.raw,
  });
} 