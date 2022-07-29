import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
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
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: MainColor.darkGreyColor,
          title: Styles.appBarText('تحويل ملفك إلي صيغة PDF', context),
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
    );
  }
}
