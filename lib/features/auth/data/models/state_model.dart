import 'package:equatable/equatable.dart';

class StateModell extends Equatable {
  final int id;
  final String name;

  const StateModell({
    required this.id,
    required this.name,
  });

  factory StateModell.fromJson(Map<String, dynamic> json) {
    return StateModell(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id];
} 