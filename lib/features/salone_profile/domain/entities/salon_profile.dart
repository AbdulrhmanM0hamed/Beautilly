class SalonProfile {
  final int id;
  final String name;
  final String type;
  final String? description;
  final String address;
  final String phone;
  final String email;
  final String googleMapsUrl;
  final double fakeAverageRating;
  final bool isActive;
  final Location location;
  final List<WorkingHour> workingHours;
  final List<Service> services;
  final List<Discount> discounts;
  final List<Staff> staff;
  final SalonImages images;
  final RatingsSummary ratings;

  const SalonProfile({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.address,
    required this.phone,
    required this.email,
    required this.googleMapsUrl,
    required this.fakeAverageRating,
    required this.isActive,
    required this.location,
    required this.workingHours,
    required this.services,
    required this.discounts,
    required this.staff,
    required this.images,
    required this.ratings,
  });
}

class Location {
  final String city;
  final String state;
  final String country;

  const Location({
    required this.city,
    required this.state,
    required this.country,
  });
}

class WorkingHour {
  final String day;
  final String openingTime;
  final String closingTime;

  const WorkingHour({
    required this.day,
    required this.openingTime,
    required this.closingTime,
  });
}

class Service {
  final int id;
  final String name;
  final String description;
  final String type;
  final String price;
  final String image;

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.price,
    required this.image,
  });
}

class Discount {
  final int id;
  final String title;
  final String description;
  final String discountType;
  final String discountValue;
  final DiscountPricing pricing;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isActive;
  final bool isValid;
  final List<DiscountService> services;

  const Discount({
    required this.id,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.pricing,
    required this.validFrom,
    required this.validUntil,
    required this.isActive,
    required this.isValid,
    required this.services,
  });
}

class DiscountPricing {
  final String originalPrice;
  final String discountType;
  final String discountValue;
  final String finalPrice;
  final String discountAmount;
  final String savingsPercentage;

  const DiscountPricing({
    required this.originalPrice,
    required this.discountType,
    required this.discountValue,
    required this.finalPrice,
    required this.discountAmount,
    required this.savingsPercentage,
  });

  Map<String, dynamic> toJson() => {
    'original_price': originalPrice,
    'discount_type': discountType,
    'discount_value': discountValue,
    'final_price': finalPrice,
    'discount_amount': discountAmount,
    'savings_percentage': savingsPercentage,
  };
}

class DiscountService {
  final int id;
  final String name;
  final String price;

  const DiscountService({
    required this.id,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
  };
}

class Staff {
  final int id;
  final String name;
  final String role;
  final String image;

  const Staff({
    required this.id,
    required this.name,
    required this.role,
    required this.image,
  });
}

class SalonImages {
  final String main;
  final String mainThumb;
  final String mainMedium;
  final List<String> gallery;

  const SalonImages({
    required this.main,
    required this.mainThumb,
    required this.mainMedium,
    required this.gallery,
  });
}

class RatingsSummary {
  final double average;
  final int count;
  final List<Rating> ratings;

  const RatingsSummary({
    required this.average,
    required this.count,
    required this.ratings,
  });
}

class Rating {
  final int id;
  final int rating;
  final String? comment;
  final User user;
  final String createdAt;

  const Rating({
    required this.id,
    required this.rating,
    this.comment,
    required this.user,
    required this.createdAt,
  });
}

class User {
  final int id;
  final String name;
  final String? avatar;

  const User({
    required this.id,
    required this.name,
    this.avatar,
  });
} 