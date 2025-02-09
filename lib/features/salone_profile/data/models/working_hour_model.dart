import '../../domain/entities/salon_profile.dart';

class WorkingHourModel extends WorkingHour {
  const WorkingHourModel({
    required super.day,
    required super.openingTime,
    required super.closingTime,
  });

  factory WorkingHourModel.fromJson(Map<String, dynamic> json) {
    return WorkingHourModel(
      day: json['day'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'opening_time': openingTime,
      'closing_time': closingTime,
    };
  }
} 