class StatisticsModel {
  final int happyClients;
  final int services;
  final int fashionHouses;
  final int beautySalons;

  StatisticsModel({
    required this.happyClients,
    required this.services,
    required this.fashionHouses,
    required this.beautySalons,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      happyClients: json['happyClients'] ?? 0,
      services: json['services'] ?? 0,
      fashionHouses: json['fashionHouses'] ?? 0,
      beautySalons: json['beautySalons'] ?? 0,
    );
  }
}
