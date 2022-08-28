import 'package:cloud_firestore/cloud_firestore.dart';

class City {
  String? locationNameEn;
  String? locationNameAr;
  double? latitude;
  double? langitude;

  City(
      {required this.locationNameAr,
      required this.locationNameEn,
      required this.langitude,
      required this.latitude});

  static City fromSnapShot(DocumentSnapshot snapshot) {
    City governorate = City(
      locationNameAr: snapshot['cityNameAr'],
      locationNameEn: snapshot['cityNameEn'],
      latitude: snapshot['latitude'],
      langitude: snapshot['longitude'],
    );
    return governorate;
  }

  Map<String, dynamic> toMap() {
    return {
      'cityNameAr': locationNameAr,
      'cityNameEn': locationNameEn,
      'latitude': latitude,
      'langitude': langitude
    };
  }
}
