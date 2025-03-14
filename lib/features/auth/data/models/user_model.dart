import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatar;
  final int? cityId;
  final int? stateId;

  const UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatar,
    this.cityId,
    this.stateId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      cityId: json['city_id'],
      stateId: json['state_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (avatar != null) 'avatar': avatar,
      if (cityId != null) 'city_id': cityId,
      if (stateId != null) 'state_id': stateId,
    };
  }

  @override
  List<Object?> get props => [id, name, email, phone, avatar, cityId, stateId];
}
