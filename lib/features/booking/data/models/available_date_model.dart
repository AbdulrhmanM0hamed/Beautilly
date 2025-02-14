import '../../domain/entities/available_time.dart';

class AvailableDateModel extends AvailableDate {
  const AvailableDateModel({
    
    required super.date,
    required super.dayName,
    required super.dayId,
    required super.formattedDate,
    required super.timeSlots,
  });

  factory AvailableDateModel.fromJson(Map<String, dynamic> json) {
    return AvailableDateModel(
      date: json['date'],
      dayName: json['day_name'],
      dayId: json['day_id'],
      formattedDate: json['formatted_date'],
      timeSlots: (json['time_slots'] as List)
          .map((slot) => TimeSlotModel.fromJson(slot))
          .toList(),
    );
  }
}

class TimeSlotModel extends TimeSlot {
  const TimeSlotModel({
    required super.id,
    required super.time,
    required super.formattedTime,
    required super.isAvailable,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'],
      time: json['time'],
      formattedTime: json['formatted_time'],
      isAvailable: json['is_available'],
    );
  }
} 