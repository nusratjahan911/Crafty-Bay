class ReviewModel {
  final String id;
  final String firstName;
  final String lastName;
  final String userId;
  final String review;
  final int? rating;

  ReviewModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userId,
    required this.review,
    required this.rating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
        id: json['_id'],
        firstName: json['user']['first_name'],
        lastName: json['user']['last_name'],
        userId: json['user']['_id'],
        review: json['comment'],
        rating: json['rating'] ?? 0
    );
  }

}
