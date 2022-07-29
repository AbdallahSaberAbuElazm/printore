import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectModel {
  String? userId;
  String? printOfficeId;

  ConnectModel({required this.userId, required this.printOfficeId});

  static ConnectModel fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return ConnectModel(
        userId: snapshot['userId'], printOfficeId: snapshot['printOfficeId']);
  }

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'printOfficeId': printOfficeId};
  }
}
