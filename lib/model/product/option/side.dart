import 'package:cloud_firestore/cloud_firestore.dart';

class Side {
  final String sideName;
  final double price;
  final int side;

  Side({required this.sideName, required this.price, required this.side});

  static Side fromSnapShot(DocumentSnapshot snapshot) {
    Side size = Side(
        sideName: snapshot['sideName'],
        price: snapshot['price'].toDouble(),
        side: snapshot['side']);
    return size;
  }

  Map<String, dynamic> toMap() {
    return {'sideName': sideName, 'price': price, 'side': side};
  }
}
