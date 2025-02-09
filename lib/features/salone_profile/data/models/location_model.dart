import '../../domain/entities/salon_profile.dart';

class LocationModel extends Location {
  const LocationModel({
    required super.city,
    required super.state,
    required super.country,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'state': state,
      'country': country,
    };
  }
} 