class SalonModel {
  final String name;
  final String image;
  final String address;
  final double rating;
  final int reviewCount;
  final List<String> services;

  const SalonModel({
    required this.name,
    required this.image,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.services,
  });
}
