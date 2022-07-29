import 'package:cloud_firestore/cloud_firestore.dart';

class Wrapping {
  final String optionName;
  final String downloadUrl;

  Wrapping({required this.optionName, required this.downloadUrl});

  static Wrapping fromSnapShot(DocumentSnapshot snapshot) {
    return Wrapping(
        optionName: snapshot['wrapping_name'],
        downloadUrl: snapshot['downloadUrl']);
  }
}
