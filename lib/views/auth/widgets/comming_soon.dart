import 'package:flutter/material.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/home_page.dart';

class CommingSoon extends StatelessWidget {
  const CommingSoon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: ListView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 8,
              bottom: MediaQuery.of(context).size.height / 8,
            ),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Image.asset(
                  'assets/images/comming_soon.png',
                ),
              ),
              Text(
                'عذراً الصفحة تحت الإعداد',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              Text(
                'وسنوافيكم بكل جديد عن التطبيق',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                            recentPage: const HomePage(), selectedIndex: 0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.6,
                      height: 47,
                      padding: const EdgeInsets.only(left: 6, right: 6),
                      decoration: BoxDecoration(
                          color: MainColor.darkGreyColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 8,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ]),
                      child: Center(
                        child: Text(
                          'الرجوع للصفحة الرئيسية',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 9,
                child: Image.asset(
                  'assets/images/printore.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ));
  }
}
