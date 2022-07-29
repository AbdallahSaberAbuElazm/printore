import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/views/shared/constant/constant.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/home_page.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeUser extends StatelessWidget {
  const QRCodeUser({Key? key}) : super(key: key);

  Future<bool> _onWillPop() async {
    return (await Get.off(
          () => Home(
            recentPage: const HomePage(),
            selectedIndex: 0,
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: MainColor.darkGreyColor,
              title: Styles.appBarText('كود الإستلام', context),
              centerTitle: true,
              leading: const SizedBox.shrink(),
              actions: [
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      onPressed: () => Get.off(
                        () => Home(
                          recentPage: const HomePage(),
                          selectedIndex: 0,
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 26,
                      ),
                    )),
              ],
            ),
            body: Stack(
              children: [
                Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    QrImage(
                      data:
                          '${Constant.user!.uid}${UserSharedPreferences.getUserName()}',
                      size: MediaQuery.of(context).size.width * 0.7,
                      backgroundColor: Colors.white,
                    ),
                    Flexible(
                        child: Container(
                      padding: const EdgeInsets.only(top: 30),
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'من فضلك إظهر الكود عند إستلامك لأوراقك المطبوعة لإتمام العملية',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ))
                  ],
                )),
                // Align(
                //     alignment: FractionalOffset.bottomCenter,
                //     child: ClipPath(
                //       clipper: CurvedTopClipper(),
                //       child: Container(
                //         color: MainColor.darkGreyColor,
                //         height: 250,
                //         child: Center(
                //             child: Padding(
                //           padding: const EdgeInsets.only(top: 50),
                //           child: Text(
                //             'sdfsdfdsf',
                //             style: TextStyle(color: MainColor.yellowColor),
                //           ),
                //         )),
                //       ),
                //     ))
              ],
            ),
          )),
    );
  }
}

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final roundingHeight = size.height * 3 / 5;
    final filledRectangle =
        Rect.fromLTRB(0, size.height - roundingHeight, size.width, 0);
    final roundingRectangle = Rect.fromLTRB(
        -5, size.height, size.width + 5, size.height - roundingHeight * 2);
    final path = Path();
    path.addRect(filledRectangle);
    path.arcTo(roundingRectangle, pi, -pi, true);
    path.close();
    return path;
    // throw UnimplementedError();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
    // throw UnimplementedError();
  }
}
