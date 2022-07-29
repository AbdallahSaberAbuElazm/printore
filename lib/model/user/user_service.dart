import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  bool? printingOfficer;
  bool? mobileVerified;
  String? avatarUrl;
  bool? universityStudent = false;
  bool? isAdmin = false;

  UserService(
      this.firstName,
      this.lastName,
      this.email,
      this.mobile,
      this.universityStudent,
      this.userId,
      this.avatarUrl,
      this.mobileVerified,
      this.printingOfficer,
      this.isAdmin);

  UserService.fromDocumentSnapshot(DocumentSnapshot jsonObject) {
    userId = jsonObject['userId'];
    firstName = jsonObject['first_name'];
    lastName = jsonObject['last_name'];
    email = jsonObject['email'];
    mobile = jsonObject['mobile'];
    universityStudent = jsonObject['universiity_student'];
    printingOfficer = jsonObject['printingOfficer'];
    mobileVerified = jsonObject['mobile_verified'];
    avatarUrl = jsonObject['avatarUrl'];
    isAdmin = jsonObject['isAdmin'];
  }
}
