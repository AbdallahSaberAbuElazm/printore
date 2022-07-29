import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/widgets/button_center_button.dart';
import 'package:printore/views/shared/widgets/user_navigation_drawer.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/home_page.dart';
import 'package:printore/views/user_layout/profile/address_card.dart';
import 'package:printore/views/user_layout/profile/new_address.dart';

class MyAddress extends StatelessWidget {
  MyAddress({Key? key}) : super(key: key);
  final int length = 0;

  Future<bool> _onWillPop() async {
    return (await Get.off(
          () => Home(
            recentPage: const HomePage(),
            selectedIndex: 0,
          ),
        )) ??
        false;
  }

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: AdvancedDrawer(
                backdropColor: const Color.fromARGB(255, 236, 239, 241),
                controller: _advancedDrawerController,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 80),
                animateChildDecoration: true,
                rtlOpening: true,
                // openScale: 1.0,
                disabledGestures: false,
                childDecoration: const BoxDecoration(
                  // NOTICE: Uncomment if you want to add shadow behind the page.
                  // Keep in mind that it may cause animation jerks.
                  // boxShadow: <BoxShadow>[
                  //   BoxShadow(
                  //     color: Colors.black12,
                  //     blurRadius: 0.0,
                  //   ),
                  // ],
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                drawer: const UserNavigationDrawer(),
                child: Scaffold(
                    backgroundColor: Theme.of(context).backgroundColor,
                    appBar: AppBar(
                      backgroundColor: MainColor.darkGreyColor,
                      title: Styles.appBarText('عناويني', context),
                      centerTitle: true,
                      leading: IconButton(
                        onPressed: _handleMenuButtonPressed,
                        icon: ValueListenableBuilder<AdvancedDrawerValue>(
                          valueListenable: _advancedDrawerController,
                          builder: (_, value, __) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Icon(
                                value.visible ? Icons.clear : Icons.menu,
                                key: ValueKey<bool>(value.visible),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    bottomSheet: BottomCenterButton(
                        buttonTitle: 'أضف عنوان جديد',
                        onPressed: () => Get.off(() => const NewAddress()),
                        actionRelated: true),
                    body: Stack(
                      children: [
                        _selectAddress(context: context),
                      ],
                    )))));
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  Widget _selectAddress({required BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 6,
              child: Image.asset(
                'assets/images/no_address_found.png',
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Text(
                'لم تضف عناوين لك حتي الآن !!',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            // SizedBox(
            //   height: 55,
            //   width: MediaQuery.of(context).size.width / 2,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       primary: MainColor.yellowColor,
            //       shape: const RoundedRectangleBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(6)),
            //       ),
            //     ),
            //     onPressed: () => Get.off(() => const NewAddress()),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(
            //           'أضف عنوان جدبد',
            //           style: TextStyle(
            //               color: MainColor.darkGreyColor, fontSize: 16),
            //         ),
            //         const SizedBox(width: 8),
            //         Icon(
            //           Icons.add,
            //           color: MainColor.darkGreyColor,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          ]),
        ),
      ],
    );
  }
}
