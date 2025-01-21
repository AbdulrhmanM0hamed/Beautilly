import 'package:equatable/equatable.dart';

class CityModel extends Equatable {
  final int id;
  final String name;
  final int stateId;

  const CityModel({
    required this.id,
    required this.name,
    required this.stateId,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      name: json['name'],
      stateId: json['state_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state_id': stateId,
    };
  }

  @override
  List<Object?> get props => [id, name, stateId];
} 