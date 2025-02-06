class OrderRequestModel {
  final double height;
  final double weight;
  final String size;
  final String description;
  final int executionTime;
  final List<FabricModel> fabrics;
  final String imagePath;

  OrderRequestModel({
    required this.height,
    required this.weight,
    required this.size,
    required this.description,
    required this.executionTime,
    required this.fabrics,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'size': size,
      'description': description,
      'execution_time': executionTime,
      'fabrics': fabrics.map((fabric) => fabric.toJson()).toList(),
    };
  }
}

class FabricModel {
  final String type;
  final String color;

  FabricModel({
    required this.type,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'color': color,
    };
  }
} 