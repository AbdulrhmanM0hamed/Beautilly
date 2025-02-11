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
    required super.userInteraction,
  });

  factory SalonProfileModel.fromJson(Map<String, dynamic> json) {
    try {
      final location = LocationModel.fromJson(json['location'] ?? {});
      final workingHours = (json['working_hours'] as List?)
          ?.map((e) => WorkingHourModel.fromJson(e))
          .toList() ?? [];
      final services = (json['services'] as List?)
          ?.map((e) => ServiceModel.fromJson(e))
          .toList() ?? [];
      final discounts = (json['discounts'] as List?)
          ?.map((e) => DiscountModel.fromJson(e))
          .toList() ?? [];
      final staff = (json['staff'] as List?)
          ?.map((e) => StaffModel.fromJson(e))
          .toList() ?? [];
      final images = SalonImagesModel.fromJson(json['images'] ?? {});
      final ratings = RatingsSummaryModel.fromJson(json['ratings'] ?? {
        'average': 0.0,
        'count': 0,
        'ratings': []
      });
      final userInteraction = UserInteractionModel.fromJson(
        json['user_interaction'] is Map 
            ? json['user_interaction'] 
            : {}
      );

      return SalonProfileModel(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        description: json['description'],
        address: json['address'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '',
        googleMapsUrl: json['google_maps_url'] ?? '',
        fakeAverageRating: (json['fake_average_rating'] ?? 0).toDouble(),
        isActive: json['is_active'] == 1 || json['is_active'] == true,
        location: location,
        workingHours: workingHours,
        services: services,
        discounts: discounts,
        staff: staff,
        images: images,
        ratings: ratings,
        userInteraction: userInteraction,
      );
    } catch (e) {
      rethrow;
    }
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
      'user_interaction': (userInteraction as UserInteractionModel).toJson(),
    };
  }
}

class UserInteractionModel extends UserInteraction {
  const UserInteractionModel({
    required super.hasRated,
    required super.hasLiked,
    super.userRating,
  });

  factory UserInteractionModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return const UserInteractionModel(
        hasRated: false,
        hasLiked: false,
      );
    }

    try {
      Rating? userRating;
      if (json['user_rating'] != null) {
        if (json['user_rating'] is Map) {
          userRating = RatingModel.fromJson(json['user_rating']);
        } else {
          userRating = Rating(
            id: 0,
            rating: (json['user_rating'] as num).toInt(),
            user: const User(id: 0, name: ''),
            createdAt: '',
          );
        }
      }

      return UserInteractionModel(
        hasRated: json['has_rated'] ?? false,
        hasLiked: json['has_liked'] ?? false,
        userRating: userRating,
      );
    } catch (e) {
      return const UserInteractionModel(
        hasRated: false,
        hasLiked: false,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'has_rated': hasRated,
      'has_liked': hasLiked,
      'user_rating': userRating != null ? (userRating as RatingModel).toJson() : null,
    };
  }
} 