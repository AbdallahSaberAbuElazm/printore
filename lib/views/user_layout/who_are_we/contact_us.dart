import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/advanced_drawer.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/widgets/user_navigation_drawer.dart';
import 'package:printore/views/user_layout/who_are_we/complaint.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
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
                body: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 8,
                              bottom: 60),
                          child: ListView(
                            children: [
                              _drawInfo(
                                  hint: 'إحنا معاك في كا مكان',
                                  iconData: Icons.location_on_outlined),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 12,
                              ),
                              _drawInfo(
                                  hint: '01559887381',
                                  iconData: Icons.whatsapp_outlined),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 12,
                              ),
                              _drawInfo(
                                  hint: 'ahmed19981511@gmail.com',
                                  iconData: Icons.email_outlined),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 12,
                              ),
                              _sendComplaint()
                            ],
                          ),
                        ))))));
  }

  Widget _drawInfo({required String hint, required IconData iconData}) {
    return Stack(
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                color: MainColor.darkGreyColor,
                width: MediaQuery.of(context).size.width / 1.4,
                height: 90,
              ),
              Transform(
                transform: Matrix4.skewY(-0.1),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 90,
                ),
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: Offset(-MediaQuery.of(context).size.width / 9,
              MediaQuery.of(context).size.width / 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    width: 55,
                    height: 55,
                  ),
                  Icon(iconData, size: 50, color: MainColor.darkGreyColor),
                ],
              ),
              SizedBox(width: MediaQuery.of(context).size.width / 15),
              SizedBox(
                width: 165,
                child: Text(
                  hint,
                  style:
                      TextStyle(color: MainColor.darkGreyColor, fontSize: 15.3),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  //send complaint
  Widget _sendComplaint() {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Center(
        child: Styles.loginButton(context, 'إرسال شكوي',
            () => Complaint.showComplaintDialog(context: context)));
  }
}
