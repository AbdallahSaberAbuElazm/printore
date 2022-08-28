import 'package:cloud_firestore/cloud_firestore.dart';

class Wrapping {
  final String optionName;
  final String downloadUrl;
  final double price;

  Wrapping(
      {required this.optionName,
      required this.downloadUrl,
      required this.price});

  static Wrapping fromSnapShot(DocumentSnapshot snapshot) {
    return Wrapping(
        optionName: snapshot['wrapping_name'],
        downloadUrl: snapshot['downloadUrl'],
        price: snapshot['price'].toDouble());
  }

  Map<String, dynamic> toMap() {
    return {
      'wrapping_name': optionName,
      'downloadUrl': downloadUrl,
      'price': price
    };
  }
}
