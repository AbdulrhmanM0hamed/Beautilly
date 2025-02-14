import 'package:equatable/equatable.dart';

class AvailableDate {
  final String date;
  final String dayName;
  final int dayId;
  final String formattedDate;
  final List<TimeSlot> timeSlots;

  const AvailableDate({
    required this.date,
    required this.dayName,
    required this.dayId,
    required this.formattedDate,
    required this.timeSlots,
  });
}

class TimeSlot extends Equatable {
  final int id;
  final String time;
  final String formattedTime;
  final bool isAvailable;

  const TimeSlot({
    required this.id,
    required this.time,
    required this.formattedTime,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [id, time, formattedTime];
} 