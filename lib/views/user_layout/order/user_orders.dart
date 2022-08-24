import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/advanced_drawer.dart';
import 'package:printore/views/shared/widgets/user_navigation_drawer.dart';

class UserOrders extends StatelessWidget {
  UserOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AdvancedDrawer(
            backdropColor: const Color.fromARGB(255, 236, 239, 241),
            controller: AdvancedDrawerClass.advancedDrawerController,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 80),
            animateChildDecoration: true,
            rtlOpening: true,
            disabledGestures: false,
            childDecoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            drawer: const UserNavigationDrawer(),
            child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).backgroundColor,
                title: Text('تواصل معانا',
                    style: TextStyle(
                        color: MainColor.darkGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                centerTitle: true,
                leading: IconButton(
                  onPressed: AdvancedDrawerClass.handleMenuButtonPressed,
                  icon: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable:
                        AdvancedDrawerClass.advancedDrawerController,
                    builder: (_, value, __) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          value.visible ? Icons.clear : Icons.menu,
                          color: MainColor.darkGreyColor,
                          key: ValueKey<bool>(value.visible),
                        ),
                      );
                    },
                  ),
                ),
              ),
              body: Container(),
            )));
  }
}
