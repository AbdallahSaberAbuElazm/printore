import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String? userId;
  String? rating;
  List? improvements;
  String? opinions;

  Review(
      {required this.userId,
      required this.rating,
      required this.improvements,
      this.opinions});

  static Review fromSnapShot(DocumentSnapshot snapshot) {
    return Review(
        rating: snapshot['rating'],
        improvements: List<String>.from(snapshot['improvements']),
        opinions: snapshot['opinions'],
        userId: snapshot['useId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rating': rating,
      'improvements': improvements,
      'opinions': opinions
    };
  }
}
