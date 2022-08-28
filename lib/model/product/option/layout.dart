import 'package:cloud_firestore/cloud_firestore.dart';

class Layout {
  final String optionName;
  final String downloadUrl;
  final double price;
  final int layoutNumber;

  Layout(
      {required this.optionName,
      required this.downloadUrl,
      required this.price,
      required this.layoutNumber});

  static Layout fromSnapShot(DocumentSnapshot snapshot) {
    Layout layout = Layout(
        optionName: snapshot['layout_name'],
        downloadUrl: snapshot['downloadUrl'],
        price: snapshot['price'].toDouble(),
        layoutNumber: snapshot['layoutNumber']);
    return layout;
  }

  Map<String, dynamic> toMap() {
    return {
      'layout_name': optionName,
      'downloadUrl': downloadUrl,
      'price': price,
      'layoutNumber': layoutNumber,
    };
  }
}
