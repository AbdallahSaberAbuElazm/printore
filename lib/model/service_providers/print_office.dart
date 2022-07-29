import 'package:cloud_firestore/cloud_firestore.dart';

class PrintOffice {
  String? id;
  String? printOfficeName;
  String? printOfficeUrl;
  String? printOfficeAddress;
  double? printOfficeRating;
  String? city;
  String? governorate;
  bool? status = false;

  PrintOffice(
      {required this.id,
      required this.printOfficeName,
      required this.printOfficeUrl,
      required this.printOfficeAddress,
      required this.printOfficeRating,
      required this.city,
      required this.governorate,
      required this.status});

  static PrintOffice fromSnapShot(DocumentSnapshot snapshot) {
    return PrintOffice(
        id: snapshot['printOfficeId'],
        printOfficeName: snapshot['printOfficeName'],
        printOfficeAddress: snapshot['printOfficeAddress'],
        printOfficeUrl: snapshot['printOfficeUrl'],
        printOfficeRating: snapshot['rating'].toDouble(),
        city: snapshot['city'],
        governorate: snapshot['governorate'],
        status: snapshot['status']);
  }

  Map<String, dynamic> toMap() {
    return {
      'printOfficeName': printOfficeName,
      'printOfficeUrl': printOfficeUrl,
      'printOfficeAddress': printOfficeAddress,
      'rating': printOfficeRating,
      'status': status,
    };
  }
}
