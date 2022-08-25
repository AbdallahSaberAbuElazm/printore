import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';

import 'package:printore/views/shared/widgets/user_navigation_drawer.dart';

class WhoAreWe extends StatelessWidget {
  WhoAreWe({Key? key}) : super(key: key);
  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AdvancedDrawer(
            backdropColor: const Color.fromARGB(255, 236, 239, 241),
            controller: _advancedDrawerController,
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
                  backgroundColor: MainColor.darkGreyColor,
                  title: Styles.appBarText('تعرف علينا', context),
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
                            color: Colors.white,
                            key: ValueKey<bool>(value.visible),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                body: ListView(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 15,
                            bottom: 30),
                        child: Styles.logo(width: 120, height: 110)),
                    Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: Text(
                        'برنتور هي منصة للتعايش مع طلبات الطباعة في السوق وخاصة مع الشباب الجامعي، ونهدف لتيسير عملية الطباعة للأوراق والمستندات الخاص بكم أونلاين بأعلي جودة وبأنسب سعر وأفضل خدمة توصيل ممتازة دون مجهود مبذول من حضراتكم أو قضاء وقت انتظار كبير في المكتبات حتي تتم طباعة مستنداتكم. ',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 15,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 4,
                        child: Center(
                          child: Image.asset(
                            'assets/images/aboutUs.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ))));
  }
}
