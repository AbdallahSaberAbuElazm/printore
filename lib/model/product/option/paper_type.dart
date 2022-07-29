import 'package:cloud_firestore/cloud_firestore.dart';

class PaperType {
  final String optionName;

  PaperType({required this.optionName});

  static PaperType fromSnapShot(DocumentSnapshot snapshot) {
    return PaperType(optionName: snapshot['paperTypeName']);
  }
}
