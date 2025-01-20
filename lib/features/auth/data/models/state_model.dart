class StateModel {
  final int id;
  final String name;

  StateModel({required this.id, required this.name});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StateModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 