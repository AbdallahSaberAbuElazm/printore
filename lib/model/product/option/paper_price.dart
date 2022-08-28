import 'package:cloud_firestore/cloud_firestore.dart';

class PaperPrice {
  final String paperColor;
  final double price;

  PaperPrice({required this.paperColor, required this.price});

  static PaperPrice fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return PaperPrice(
        paperColor: snapshot['paperColor'],
        price: snapshot['price'].toDouble());
  }

  Map<String, dynamic> toMap() {
    return {'paperColor': paperColor, 'price': price};
  }
}
