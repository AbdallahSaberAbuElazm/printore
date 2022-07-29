import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String? rating;
  String? improvements;
  String? opinions;

  Review({required this.rating, required this.improvements, this.opinions});

  static Review fromSnapShot(DocumentSnapshot snapshot) {
    Review review = Review(
        rating: snapshot['rating'],
        improvements: snapshot['improvements'],
        opinions: snapshot['opinions']);
    return review;
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'improvements': improvements,
      'opinions': opinions
    };
  }
}
