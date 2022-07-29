import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:printore/views/admin/add_print_officers.dart';
import 'package:printore/views/print_office_layout/po_home_page.dart';
import 'package:printore/views/print_office_layout/print_office_home.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:printore/views/shared/util/util.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/home_page.dart';

class FireAuth {
  static Future<User?> registerUsingEmailPassword({
    required String firstName,
    required String lastName,
    required String email,
    required bool universityStudent,
    required String mobile,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
            child: CircularProgressIndicator(color: MainColor.darkGreyColor)));
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateProfile(displayName: firstName + lastName);
      await user.reload();
      user = auth.currentUser;
      if (user != null) {
        final data = {
          'userId': user.uid,
          'first_name': firstName,
          'last_name': lastName,
          'email': user.email,
          'universiity_student': universityStudent,
          'mobile': mobile,
          'mobile_verified': false,
          'avatarUrl': '',
          'printingOfficer': false,
          'isAdmin': false,
        };
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(data);
        // UserService.fromJson();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utils.snackBar(msg: 'الرقم السري ضعيف للغاية', context: context);
      } else if (e.code == 'email-already-in-use') {
        Utils.snackBar(msg: 'هذا الحساب موجود بالفعل', context: context);
      }
    } catch (e) {
      Utils.snackBar(msg: 'أعد التسجيل من فضلك', context: context);
    }
    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
            child: CircularProgressIndicator(color: MainColor.darkGreyColor)));
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      final result = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (user.emailVerified == true) {
        await getUserInfo(
          user: user,
          result: result,
        );
        if (result['isAdmin'] == true && result['printingOfficer'] == false) {
          Get.off(() => const AddPrintOfficers());
        } else if (result['printingOfficer'] == false) {
          Get.off(
            () => Home(
              recentPage: const HomePage(),
              selectedIndex: 0,
            ),
          );
        } else if (result['printingOfficer'] == true) {
          Get.off(
            () => PrintOfficeHome(
              recentPage: const PrintOfficeHomePage(),
              selectedIndex: 0,
            ),
          );
        }
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        if (user.email!.isNotEmpty) {
          Utils.snackBar(
              msg: 'يرجي تأكيد البريد الإلكتروني من بريدك الإلكتروني',
              context: context);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Navigator.pop(context);
        Utils.snackBar(msg: 'لا يوجد مستخدم لهذا الحساب', context: context);
        Navigator.pop(context);
      } else if (e.code == 'wrong-password') {
        Navigator.pop(context);
        Utils.snackBar(
            msg: 'الرقم السري الذي ادخلته غير صحيح', context: context);
        Navigator.pop(context);
      }
    }

    return user;
  }

  static getUserInfo({
    required User user,
    required DocumentSnapshot<Map<String, dynamic>> result,
  }) async {
    await UserSharedPreferences.setUserInfo(
        email: result['email'],
        fName: result['first_name'],
        lName: result['last_name'],
        phoneNumber: result['mobile'],
        avatarUrl: (result['avatarUrl'] != null) ? result['avatarUrl'] : '',
        avatarName:
            (result['avatarUrl'] != null) ? basename(result['avatarUrl']) : '',
        printingOfficer: result['printingOfficer'],
        isAdmin: result['isAdmin']);
    if (result['printingOfficer'] == true) {
      final address = await FirebaseFirestore.instance
          .collection('addresses')
          .doc(user.uid)
          .get();
      final printOffice = await FirebaseFirestore.instance
          .collection('serviceProvidersPrintOffices')
          .doc(address['governorateName'])
          .collection(address['cityName'])
          .doc(user.uid)
          .get();

      await UserSharedPreferences.setPrintOfficeInfo(
          printOfficeName: printOffice['printOfficeName'],
          printOfficeAddress: printOffice['printOfficeAddress'],
          printOfficeLocationGovernorate: address['governorateName'],
          printOfficeLocationCity: address['cityName']);
    }
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  static Future resetPassword(
      {@required BuildContext? context, @required String? email}) async {
    showDialog(
        context: context!,
        barrierDismissible: false,
        builder: (context) => Center(
            child: CircularProgressIndicator(color: MainColor.darkGreyColor)));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
      showDialog(
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 0.7,
                  height: 270,
                  child: AlertDialog(
                      backgroundColor: MainColor.darkGreyColor,
                      content: Column(
                        children: [
                          Text(
                            'تم إرسال ربط تغيير كلمة المرور الي بريدك الإلكتروني',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shadowColor: MainColor.yellowColor,
                                minimumSize: const Size.fromHeight(50),
                                primary: MainColor.yellowColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                              ),
                              onPressed: (() => Navigator.of(context)
                                  .popAndPushNamed('login')),
                              child: Text(
                                'نعم',
                                style: Theme.of(context).textTheme.bodyText2,
                              )),
                        ],
                      )),
                ),
              ),
            );
          });
    } on FirebaseAuthException catch (e) {
      Utils.snackBar(context: context, msg: e.message);
      Navigator.of(context).pop();
    }
  }
}
