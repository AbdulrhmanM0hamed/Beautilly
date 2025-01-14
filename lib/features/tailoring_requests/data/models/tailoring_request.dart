class TailoringRequest {
  final String id;
  final String clientName;
  final String clientImage;
  final String designImage;
  final double height;
  final double weight;
  final String size;
  final List<FabricDetail> fabrics;
  final int executionDays;
  final String description;
  final DateTime createdAt;
  final String status;

  TailoringRequest({
    required this.id,
    required this.clientName,
    required this.clientImage,
    required this.designImage,
    required this.height,
    required this.weight,
    required this.size,
    required this.fabrics,
    required this.executionDays,
    required this.description,
    required this.createdAt,
    required this.status,
  });
}

class FabricDetail {
  String type;
  String color;

  FabricDetail({
    required this.type,
    required this.color,
  });
}
