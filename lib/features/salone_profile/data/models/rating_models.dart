import '../../domain/entities/salon_profile.dart';

class RatingsSummaryModel extends RatingsSummary {
  const RatingsSummaryModel({
    required super.average,
    required super.count,
    required super.ratings,
  });

  factory RatingsSummaryModel.fromJson(Map<String, dynamic> json) {
    return RatingsSummaryModel(
      average: (json['average'] ?? 0).toDouble() ?? 0,
      count: json['count'] ?? 0,
      ratings: (json['ratings'] as List?)
          ?.map((e) => RatingModel.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average ?? 0,
      'count': count ?? 0,
      'ratings': (ratings as List<RatingModel>)
          .map((e) => e.toJson())
          .toList(),
    };
  }
}

class RatingModel extends Rating {
  const RatingModel({
    required super.id,
    required super.rating,
    super.comment,
    required super.user,
    required super.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      user: UserModel.fromJson(json['user']),
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'rating': rating ?? 0,
      'comment': comment ?? '',
      'user': (user as UserModel).toJson(),
      'created_at': createdAt ?? '',
    };
  }
}

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    super.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'name': name ?? '',
      'avatar': avatar ?? '',
    };
  }
} 