import '../../domain/entities/salon_profile.dart';

class RatingsSummaryModel extends RatingsSummary {
  const RatingsSummaryModel({
    required super.average,
    required super.count,
    required super.ratings,
  });

  factory RatingsSummaryModel.fromJson(Map<String, dynamic> json) {
    return RatingsSummaryModel(
      average: (json['average'] as num).toDouble(),
      count: json['count'],
      ratings: (json['ratings'] as List)
          .map((e) => RatingModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'count': count,
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
    required super.comment,
    required super.user,
    required super.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      rating: json['rating'],
      comment: json['comment'],
      user: RatingUserModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'user': (user as RatingUserModel).toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class RatingUserModel extends RatingUser {
  const RatingUserModel({
    required super.id,
    required super.name,
    required super.avatar,
  });

  factory RatingUserModel.fromJson(Map<String, dynamic> json) {
    return RatingUserModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
    };
  }
} 