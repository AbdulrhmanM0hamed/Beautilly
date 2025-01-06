class FashionHouseModel {
  final String name;
  final String image;
  final List<String> specialties;
  final String location;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final List<String> tags;

  const FashionHouseModel({
    required this.name,
    required this.image,
    required this.specialties,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.tags,
  });
}
