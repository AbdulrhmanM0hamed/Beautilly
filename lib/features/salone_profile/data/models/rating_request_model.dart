class RatingRequestModel {
  final int rating;
  final String? comment;

  RatingRequestModel({
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
    };
  }
} 