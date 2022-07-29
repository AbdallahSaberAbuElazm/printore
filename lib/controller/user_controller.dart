import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:printore/services/firestore_db.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:printore/views/shared/util/util.dart';

class UserController extends GetxController {
  DocumentSnapshot<Map<String, dynamic>>? users;
  final user = FirebaseAuth.instance.currentUser;

  getSpecificUser({required String userId}) async {
    users = await FirestoreDB().getSpecificUser(userId: userId);
    update();
  }

  updateEmail({required String newEmail, required String password}) {
    FirestoreDB().updateEmail(newEmail: newEmail, password: password);
  }

  void changePassword(
      {required String currentPassword,
      required String newPassword,
      required BuildContext context}) async {
    final cred = EmailAuthProvider.credential(
        email: UserSharedPreferences.getUseremail().toString(),
        password: currentPassword);

    user!.reauthenticateWithCredential(cred).then((value) {
      user!.updatePassword(newPassword).then((_) {
        Utils.snackBar(context: context, msg: 'تم تغيير كلمة المرور بنجاح');
      }).catchError((error) {
        //Error, show something
      });
    }).catchError((err) {});
  }

  updateUserInfo(
      {required String fName,
      required String lName,
      required String phoneNum}) {
    FirestoreDB()
        .updateUserInfo(fName: fName, lName: lName, phoneNum: phoneNum);
  }
}
