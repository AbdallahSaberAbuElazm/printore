import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:printore/views/auth/login.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: IntroductionScreen(
        globalBackgroundColor: Theme.of(context).backgroundColor,
        done: Text('اطبع', style: Theme.of(context).textTheme.headline4),
        onDone: () async {
          await UserSharedPreferences.setFirstOpen(showHome: true);
          Get.off(() => const Login());
          print('showHome : ${UserSharedPreferences.getFirstOpen()}');
        },
        showNextButton: true,
        showSkipButton: true,
        skip: Text('تخطي', style: Theme.of(context).textTheme.headline4),
        next: Icon(
          Icons.arrow_circle_left_outlined,
          size: 29,
          color: MainColor.darkGreyColor,
        ),
        dotsDecorator: getDotsDecorator(),
        pages: [
          PageViewModel(
            title: '',
            body: '',
            image: buildImage(
                path: 'assets/images/onboarding1.png',
                title1: 'إرفع ملفاتك أونلاين',
                title2: '',
                body: 'سجل دخولك وارفع ملفاتك الآن',
                context: context),
            decoration: getPageDecoration(context: context),
          ),
          PageViewModel(
            title: '',
            body: '',
            image: buildImage(
                path: 'assets/images/onboarding2.png',
                title1: 'إتمم خيارات وطلب',
                title2: 'الطباعة بآمان',
                body: 'بإستخدام بطاقتك البنكية أو من أقرب منفذ فودافون كاش',
                context: context),
            decoration: getPageDecoration(context: context),
          ),
          PageViewModel(
            title: '',
            body: '',
            image: buildImage(
                path: 'assets/images/onboarding3.png',
                title1: 'تهانينا',
                title2: ' استلم مطبوعات',
                body: 'التسليم عند باب البيت أو من أقرب مقدم خدمة',
                context: context),
            decoration: getPageDecoration(context: context),
          ),
        ],
      ),
    );
  }

  Widget buildImage(
          {required String path,
          required String title1,
          required String title2,
          required String body,
          required BuildContext context}) =>
      Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Center(
          child: Column(
            children: [
              Text(
                'كيف اطبع أوراقي مع ',
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: MainColor.darkGreyColor),
              ),
              Image.asset(
                'assets/images/printore.png',
                width: MediaQuery.of(context).size.width / 3.5,
                fit: BoxFit.fill,
              ),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 16,
                        left: 24,
                        right: 24),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.height / 2,
                        child: Image.asset(
                            'assets/images/backgroundOnboarding.png')),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 9, right: 34),
                    child: Center(
                      child: SizedBox(
                        width: 105,
                        height: 100,
                        child: Image.asset(
                          path,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset:
                        Offset(-24, MediaQuery.of(context).size.height / 3.7),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            title1,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: MainColor.darkGreyColor),
                          ),
                          Text(
                            title2,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: MainColor.darkGreyColor),
                          ),
                          Transform.translate(
                            offset: Offset(
                                0, -MediaQuery.of(context).size.height / 99),
                            child: SizedBox(
                              width: 200,
                              child: Text(
                                body,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey.shade600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 6),
            ],
          ),
        ),
      );
  PageDecoration getPageDecoration({required BuildContext context}) =>
      PageDecoration(
        // imagePadding: const EdgeInsets.only(top: 70, left: 24, right: 24),
        fullScreen: true,
        pageColor: Theme.of(context).backgroundColor,
      );
  DotsDecorator getDotsDecorator() => DotsDecorator(
        activeColor: MainColor.yellowColor,
        size: const Size(10, 10),
        activeSize: const Size(22, 10),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      );
}
