import 'package:cloud_firestore/cloud_firestore.dart';

class Side {
  final String sideName;

  const Side({required this.sideName});

  static Side fromSnapShot(DocumentSnapshot snapshot) {
    Side size = Side(sideName: snapshot['side_name']);
    return size;
  }

  Map<String, dynamic> toMap() {
    return {
      'size_name': sideName,
    };
  }
}
