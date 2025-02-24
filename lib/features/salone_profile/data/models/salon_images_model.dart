import '../../domain/entities/salon_profile.dart';

class SalonImagesModel extends SalonImages {
  const SalonImagesModel({
    required super.main,
    required super.mainThumb,
    required super.mainMedium,
    required super.gallery,
  });

  factory SalonImagesModel.fromJson(Map<String, dynamic> json) {
    return SalonImagesModel(
      main: json['main'] ?? '',
      mainThumb: json['main_thumb'] ?? '',
      mainMedium: json['main_medium'] ?? '',
      gallery: (json['gallery'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'main': main ?? '',
      'main_thumb': mainThumb ?? '',
      'main_medium': mainMedium ?? '',
      'gallery': gallery ?? [],
    };
  }
} 