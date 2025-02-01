import 'package:equatable/equatable.dart';

class CityModell extends Equatable {
  final int id;
  final String name;
  final int stateId;

  const CityModell({
    required this.id,
    required this.name,
    required this.stateId,
  });

  factory CityModell.fromJson(Map<String, dynamic> json) {
    return CityModell(
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
  List<Object?> get props => [id];
} 