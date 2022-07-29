import 'package:cloud_firestore/cloud_firestore.dart';

class Governorate {
  String? locationNameEn;
  String? locationNameAr;

  Governorate({required this.locationNameAr, required this.locationNameEn});

  static Governorate fromSnapShot(DocumentSnapshot snapshot) {
    Governorate governorate = Governorate(
        locationNameAr: snapshot['governorateNameAr'],
        locationNameEn: snapshot['governorateNameEn']);
    return governorate;
  }

  Map<String, dynamic> toMap() {
    return {
      'governorateNameAr': locationNameAr,
      'governorateNameEn': locationNameEn
    };
  }
}
