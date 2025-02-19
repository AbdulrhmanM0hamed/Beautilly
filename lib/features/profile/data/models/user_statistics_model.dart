import '../../domain/entities/user_statistics.dart';

class UserStatisticsModel extends UserStatistics {
  const UserStatisticsModel({
    required super.reservationsCount,
    required super.ordersCount,
    required super.favoriteShopsCount,
  });

  factory UserStatisticsModel.fromJson(Map<String, dynamic> json) {
    return UserStatisticsModel(
      reservationsCount: json['reservations_count'] ?? 0,
      ordersCount: json['orders_count'] ?? 0,
      favoriteShopsCount: json['favorite_shops_count'] ?? 0,
    );
  }
}