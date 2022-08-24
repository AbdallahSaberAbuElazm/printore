import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/advanced_drawer.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/widgets/user_navigation_drawer.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ConvertToPdf extends StatelessWidget {
  ConvertToPdf({Key? key}) : super(key: key);
  final List converts = [
    'من word إلي pdf',
    'من power point إلي pdf',
    'من excel إلي pdf',
    'من html إلي pdf',
    'من jpg إلي pdf',
  ];
  final List links = [
    'https://www.ilovepdf.com/word_to_pdf',
    'https://www.ilovepdf.com/powerpoint_to_pdf',
    'https://www.ilovepdf.com/excel_to_pdf',
    'https://www.ilovepdf.com/html-to-pdf',
    'https://www.ilovepdf.com/jpg_to_pdf'
  ];

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
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
              backgroundColor: MainColor.darkGreyColor,
              title: Styles.appBarText('تحويل ملفك إلي صيغة PDF', context),
              centerTitle: true,
              leading: IconButton(
                onPressed: AdvancedDrawerClass.handleMenuButtonPressed,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: AdvancedDrawerClass.advancedDrawerController,
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
            body: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1 / 0.6,
                    crossAxisCount: 2,
                  ),
                  itemCount: converts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 8,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () async {
                            final url = links[index];
                            if (await canLaunch(url)) {
                              await launch(url);
                            }
                          },
                          child: Center(
                            child: Text(
                              converts[index],
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ));
  }
}
