import 'package:beautilly/features/salone_profile/data/models/discount_model.dart';
import 'package:beautilly/features/salone_profile/data/models/service_model.dart';
import 'package:beautilly/features/salone_profile/data/models/location_model.dart';
import 'package:beautilly/features/salone_profile/data/models/rating_models.dart';
import 'package:beautilly/features/salone_profile/data/models/salon_images_model.dart';
import 'package:beautilly/features/salone_profile/data/models/staff_model.dart';
import 'package:beautilly/features/salone_profile/data/models/working_hour_model.dart';

import '../../domain/entities/salon_profile.dart';

class SalonProfileModel extends SalonProfile {
  const SalonProfileModel({
    required super.id,
    required super.name,
    required super.type,
    super.description,
    required super.address,
    required super.phone,
    required super.email,
    required super.googleMapsUrl,
    required super.fakeAverageRating,
    required super.isActive,
    required super.location,
    required super.workingHours,
    required super.services,
    required super.discounts,
    required super.staff,
    required super.images,
    required super.ratings,
  });

  factory SalonProfileModel.fromJson(Map<String, dynamic> json) {
    return SalonProfileModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      googleMapsUrl: json['google_maps_url'],
      fakeAverageRating: (json['fake_average_rating'] as num).toDouble(),
      isActive: json['is_active'] == 1,
      location: LocationModel.fromJson(json['location']),
      workingHours: (json['working_hours'] as List)
          .map((e) => WorkingHourModel.fromJson(e))
          .toList(),
      services: (json['services'] as List)
          .map((e) => ServiceModel.fromJson(e))
          .toList(),
      discounts: (json['discounts'] as List)
          .map((e) => DiscountModel.fromJson(e))
          .toList(),
      staff: (json['staff'] as List)
          .map((e) => StaffModel.fromJson(e))
          .toList(),
      images: SalonImagesModel.fromJson(json['images']),
      ratings: RatingsSummaryModel.fromJson(json['ratings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'google_maps_url': googleMapsUrl,
      'fake_average_rating': fakeAverageRating,
      'is_active': isActive ? 1 : 0,
      'location': (location as LocationModel).toJson(),
      'working_hours': workingHours
          .map((e) => (e as WorkingHourModel).toJson())
          .toList(),
      'services': services
          .map((e) => (e as ServiceModel).toJson())
          .toList(),
      'discounts': discounts
          .map((e) => (e as DiscountModel).toJson())
          .toList(),
      'staff': staff
          .map((e) => (e as StaffModel).toJson())
          .toList(),
      'images': (images as SalonImagesModel).toJson(),
      'ratings': (ratings as RatingsSummaryModel).toJson(),
    };
  }
} 