import 'package:cloud_firestore/cloud_firestore.dart';

class UserAddress {
  final String userName;
  final String phoneNum;
  final String location;

  UserAddress(
      {required this.userName, required this.phoneNum, required this.location});

  static UserAddress fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return UserAddress(
        userName: snapshot['username'],
        phoneNum: snapshot['phoneNumber'],
        location: snapshot['location']);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': userName,
      'phoneNumber': phoneNum,
      'location': location
    };
  }
}
