class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int stateId;
  final int cityId;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.stateId,
    required this.cityId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      stateId: json['state_id'],
      cityId: json['city_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'state_id': stateId,
      'city_id': cityId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
