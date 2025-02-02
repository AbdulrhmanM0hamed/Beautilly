import 'package:equatable/equatable.dart';

class FavoriteShop extends Equatable {
  final String name;
  final String type;
  final String image;
  final String rating;
  final int lovesCount;

  const FavoriteShop({
    required this.name,
    required this.type,
    required this.image,
    required this.rating,
    required this.lovesCount,
  });

  @override
  List<Object?> get props => [name, type, image, rating, lovesCount];
} 