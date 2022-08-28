import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/views/admin/add_print_officers.dart';
import 'package:printore/views/auth/login.dart';
import 'package:printore/views/print_office_layout/po_home_page.dart';
import 'package:printore/views/print_office_layout/print_office_home.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/home_page.dart';
import 'package:printore/views/user_layout/onboarding_page.dart';
import 'package:printore/controller/order_controller.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({Key? key}) : super(key: key);

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  String? finalEmail;
  getValidationData() async {
    setState(() {
      finalEmail = UserSharedPreferences.getUseremail();
    });
  }

  @override
  void initState() {
    getValidationData().whenComplete(() async {
      if (finalEmail != null) {
        Get.find<OrderController>();
      }
      Timer(
          const Duration(seconds: 2),
          () => Get.off(
                () => (UserSharedPreferences.getFirstOpen() == true)
                    ? finalEmail == null
                        ? const Login()
                        : (UserSharedPreferences.getPrintingOfficer() == false)
                            ? (UserSharedPreferences.getIsAdmin() == false)
                                ? Home(
                                    recentPage: const HomePage(),
                                    selectedIndex: 0,
                                  )
                                : const AddPrintOfficers()
                            : PrintOfficeHome(
                                recentPage: const PrintOfficeHomePage(),
                                selectedIndex: 0,
                              )
                    : const OnboardingPage(),
              ));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // CheckInternetConnection.CheckUserConnection(context: context);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(children: [
          Align(
            alignment: FractionalOffset.topCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.2,
              child: Image.asset(
                'assets/images/splash1.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset.center,
            child: Container(
              margin: const EdgeInsets.only(top: 40, bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 260,
                    height: 100,
                    child: Image.asset(
                      'assets/images/printore.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text("مطبوعاتك في مكان واحد",
                      style: TextStyle(
                          color: MainColor.yellowColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: "NotoKufiArabic",
                          fontStyle: FontStyle.normal,
                          fontSize: 17.0),
                      textAlign: TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _drawSubtitleText("ربح"),
                      const SizedBox(
                        width: 7,
                      ),
                      _drawImage(),
                      const SizedBox(
                        width: 7,
                      ),
                      _drawSubtitleText("جودة"),
                      const SizedBox(
                        width: 7,
                      ),
                      _drawImage(),
                      const SizedBox(
                        width: 7,
                      ),
                      _drawSubtitleText("سهولة"),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: CircularProgressIndicator(
                      color: MainColor.darkGreyColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              child: Image.asset(
                'assets/images/splash2.png',
                fit: BoxFit.fill,
                //color: const Color(0xffe5e5e5),
              ),
            ),
          ),
        ]));
  }

  Widget _drawSubtitleText(String title) {
    return Text(title,
        style: const TextStyle(
            color: Color(0xff4a6572),
            fontWeight: FontWeight.w700,
            fontFamily: "NotoKufiArabic",
            fontStyle: FontStyle.normal,
            fontSize: 15.0),
        textAlign: TextAlign.left);
  }

  Widget _drawImage() {
    return Image.asset(
      'assets/images/Icon simple-sitepoint.png',
      width: 20,
      height: 20,
      fit: BoxFit.cover,
    );
  }
}
