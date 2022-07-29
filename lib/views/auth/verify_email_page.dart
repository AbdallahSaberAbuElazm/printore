import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/views/auth/login.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/util/util.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified
        ? FirebaseAuth.instance.currentUser!.emailVerified
        : false;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified
          ? FirebaseAuth.instance.currentUser!.emailVerified
          : false;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      Utils.snackBar(context: context, msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return isEmailVerified
        ? const Login()
        : Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 90,
                    ),
                    Styles.logo(),
                    const SizedBox(height: 90),
                    Text(
                      'تم إرسال رسالة تأكيد إلي بريدك الإلكتروني',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton.icon(
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                      icon: const Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: Text(
                        'إعادة إرسال',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      style: ElevatedButton.styleFrom(
                        shadowColor: MainColor.darkGreyColor,
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Get.off(() => const Login());
                        },
                        child: Text(
                          'إلغاء',
                          style: Theme.of(context).textTheme.headline3,
                        )),
                  ],
                ),
              ),
            ));
  }
}
