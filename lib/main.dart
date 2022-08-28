import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/controller/address_controller.dart';
import 'package:printore/controller/cart_controller.dart';
import 'package:printore/controller/freq_asked_question__controller.dart';
import 'package:printore/controller/layout_controller.dart';
import 'package:printore/controller/location_controller.dart';
import 'package:printore/controller/order_controller.dart';
import 'package:printore/controller/paper_price_controller.dart';
import 'package:printore/controller/paper_type_controller.dart';
import 'package:printore/controller/print_officce_controller.dart';
import 'package:printore/controller/review_controller.dart';
import 'package:printore/controller/side_color_controller.dart';
import 'package:printore/controller/size_controller.dart';
import 'package:printore/controller/ticket_controller.dart';
import 'package:printore/controller/ticket_type_controller.dart';
import 'package:printore/controller/user_controller.dart';
import 'package:printore/controller/wrapping_controller.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/auth/check_auth.dart';
import 'package:printore/views/auth/login.dart';
import 'package:printore/views/auth/register.dart';
import 'package:printore/views/auth/verify_email_page.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:printore/views/user_layout/cart/cart_screen.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/home_page.dart';
import 'package:printore/views/user_layout/home/upload_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserSharedPreferences.init();
  runApp(const Printore());
  await getControllers();
  configLoading();
}

getControllers() {
  Get.lazyPut<UserController>(() => UserController(), fenix: true);
  Get.lazyPut<LocationController>(() => LocationController(), fenix: true);
  Get.lazyPut<PrintOfficeController>(() => PrintOfficeController(),
      fenix: true);
  Get.lazyPut<AddressController>(() => AddressController(), fenix: true);
  Get.lazyPut<FrequentlyAskedQuestionController>(
      () => FrequentlyAskedQuestionController(),
      fenix: true);
  Get.lazyPut<ReviewController>(() => ReviewController(), fenix: true);
  Get.lazyPut<SizeController>(() => SizeController(), fenix: true);
  Get.lazyPut<PaperTypeController>(() => PaperTypeController(), fenix: true);
  Get.lazyPut<LayoutController>(() => LayoutController(), fenix: true);
  Get.lazyPut<WrappingController>(() => WrappingController(), fenix: true);
  Get.lazyPut<SideColorController>(() => SideColorController(), fenix: true);
  Get.lazyPut<CartController>(() => CartController(), fenix: true);
  Get.lazyPut<OrderController>(() => OrderController(), fenix: true);
  Get.lazyPut<PaperPriceController>(() => PaperPriceController(), fenix: true);
  Get.lazyPut<TicketController>(() => TicketController(), fenix: true);
  Get.lazyPut<TicketTypeController>(() => TicketTypeController(), fenix: true);
}

void configLoading() {
  EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 2000)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..indicatorSize = 45.0
        ..radius = 10.0
        ..progressColor = Colors.white
        ..backgroundColor = MainColor.darkGreyColor
        ..indicatorColor = Colors.white
        ..textColor = Colors.white
        ..maskColor = Colors.transparent
        ..userInteractions = true
        ..dismissOnTap = false
      // ..customAnimation = CustomAnimation()
      ;
}

class Printore extends StatelessWidget {
  const Printore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider<OptionProvider>(
      create: (_) => OptionProvider(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: GetMaterialApp(
          routes: {
            'login': (context) => const Login(),
            'register': (context) => const Register(),
            'home': (context) => Home(
                  recentPage: const HomePage(),
                  selectedIndex: 0,
                ),
            'home_page': (context) => const HomePage(),
            'upload': (context) => const UploadPage(),
            'email_verification': (context) => const VerifyEmailPage(),
            'cart': (context) => CartScreen(),
          },
          initialRoute: '/',
          getPages: [
            GetPage(
              name: '/',
              page: () => Home(
                recentPage: const HomePage(),
                selectedIndex: 0,
              ),
            ),
            GetPage(
              name: '/home_page',
              page: () => const HomePage(),
            ),
            GetPage(
              name: '/upload',
              page: () => const UploadPage(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/cart',
              page: () => CartScreen(),
            ),
            GetPage(
              name: '/email_verification',
              page: () => const VerifyEmailPage(),
            ),
            GetPage(
              name: '/login',
              page: () => const Login(),
              transition: Transition.rightToLeft,
            ),
            GetPage(
              name: '/register',
              page: () => const Register(),
              transition: Transition.rightToLeft,
            ),
          ],
          theme: ThemeData(
            brightness: Brightness.light,
            backgroundColor: const Color.fromARGB(255, 223, 225, 228),
            fontFamily: 'NotoKufiArabic',
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: MainColor.darkGreyColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
            ),
            textTheme: const TextTheme(
              headline1: TextStyle(
                  color: Color(0xff344955),
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontSize: 24.0),
              headline3: TextStyle(
                color: Color(0xff344955),
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 17.0,
              ),
              headline4: TextStyle(
                  color: Color(0xff344955),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
              headline5: TextStyle(
                  color: Color(0xfff9aa33),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 21.0),
              headline6: TextStyle(
                  color: Color(0xff344955),
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0,
                  height: 1.2),
              bodyText1: TextStyle(
                  color: Color(0xff344955),
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 15.0),
              bodyText2: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 17.0),
            ),
          ),
          title: 'Printore',
          debugShowCheckedModeBanner: false,
          home: const CheckAuth(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            return const VerifyEmailPage();
          } else {
            return const Login();
          }
        });
  }
}
