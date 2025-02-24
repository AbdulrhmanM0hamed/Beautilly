import '../../domain/entities/salon_profile.dart';

class LocationModel extends Location {
  const LocationModel({
    required super.city,
    required super.state,
    required super.country,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    String getLocationName(dynamic value) {
      if (value is String) return value;
      if (value is Map) return value['name'] ?? '';
      return '';
    }

    return LocationModel(
      city: getLocationName(json['city'] ?? ''),
      state: getLocationName(json['state'] ?? ''),
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city ?? '',
      'state': state ?? '',
      'country': country ?? '',
    };
  }
} 