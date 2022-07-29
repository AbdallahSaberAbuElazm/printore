import 'package:cloud_firestore/cloud_firestore.dart';

class City {
  String? locationNameEn;
  String? locationNameAr;

  City({required this.locationNameAr, required this.locationNameEn});

  static City fromSnapShot(DocumentSnapshot snapshot) {
    City governorate = City(
        locationNameAr: snapshot['cityNameAr'],
        locationNameEn: snapshot['cityNameEn']);
    return governorate;
  }

  Map<String, dynamic> toMap() {
    return {'cityNameAr': locationNameAr, 'cityNameEn': locationNameEn};
  }
}
