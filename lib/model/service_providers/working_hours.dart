import 'package:cloud_firestore/cloud_firestore.dart';

class WorkingHours {
  String? dayName;
  String? workingHours;

  WorkingHours({required this.dayName, required this.workingHours});

  static WorkingHours fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return WorkingHours(
        dayName: snapshot['dayName'], workingHours: snapshot['workingHours']);
  }

  Map<String, dynamic> toMap() {
    return {'dayName': dayName, 'workingHours': workingHours};
  }
}
