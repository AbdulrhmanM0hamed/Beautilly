class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? phone;
  final String? address;
  final bool isActive;
  final String? stateId;
  final String? cityId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.phone,
    this.address,
    required this.isActive,
    this.stateId,
    this.cityId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      phone: json['phone'],
      address: json['address'],
      isActive: json['is_active'] == 1,
      stateId: json['state_id'],
      cityId: json['city_id'],
    );
  }
}
