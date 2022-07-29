import 'package:cloud_firestore/cloud_firestore.dart';

class Country {
  String? locationNameEn;
  String? locationNameAr;

  Country({required this.locationNameAr, required this.locationNameEn});

  static Country fromSnapShot(DocumentSnapshot snapshot) {
    Country governorate = Country(
        locationNameAr: snapshot['countryNameAr'],
        locationNameEn: snapshot['countryNameEn']);
    return governorate;
  }

  Map<String, dynamic> toMap() {
    return {'countryNameAr': locationNameAr, 'countryNameEn': locationNameEn};
  }
}
