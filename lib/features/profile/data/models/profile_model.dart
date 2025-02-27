import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? emailVerifiedAt;
  final CityModel city;
  final StateModel state;
  final String? image;
  final RoleModel role;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.emailVerifiedAt,
    required this.city,
    required this.state,
    this.image,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'email_verified_at': emailVerifiedAt,
      'city': city,
      'state': state,
      'image': image,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      emailVerifiedAt: json['email_verified_at'],
      city: CityModel.fromJson(json['city']),
      state: StateModel.fromJson(json['state']),
      image: json['avatar_url'],
      role: RoleModel.fromJson(json['role']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        emailVerifiedAt,
        city,
        state,
        image,
      ];
}

class CityModel extends Equatable {
  final int id;
  final String name;

  const CityModel({
    required this.id,
    required this.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  List<Object?> get props => [id, name];

}


class RoleModel extends Equatable {
  final int id;
  final String name;

  const RoleModel({
    required this.id,
    required this.name,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  List<Object?> get props => [id, name];
}
  



class StateModel extends Equatable {
  final int id;
  final String name;

  const StateModel({
    required this.id,
    required this.name,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  List<Object?> get props => [id, name];
}
