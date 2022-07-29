import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  String? country;
  String? governorate;
  String? city;
  String? userId;

  Address({
    required this.country,
    required this.governorate,
    required this.city,
    required this.userId,
  });

  static Address fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Address(
        country: snapshot['countryName'],
        governorate: snapshot['governorateName'],
        city: snapshot['cityName'],
        userId: snapshot['userId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'countryName': country,
      'governorateName': governorate,
      'cityName': city,
      'userId': userId,
    };
  }
}
