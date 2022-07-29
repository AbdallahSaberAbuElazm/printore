import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:printore/controller/order_controller.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/print_office_layout/po_working_hours.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:printore/views/shared/widgets/rating_builder.dart';
import 'package:provider/provider.dart';

class PrintOfficeHomePage extends StatefulWidget {
  const PrintOfficeHomePage({Key? key}) : super(key: key);

  @override
  State<PrintOfficeHomePage> createState() => _PrintOfficeHomePageState();
}

class _PrintOfficeHomePageState extends State<PrintOfficeHomePage> {
  OptionProvider? option;
  OrderController orderController = Get.find();
  User? user = FirebaseAuth.instance.currentUser;
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text(
                'هل انت متأكد ؟',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              content: Text('هل تريد الخروج من التطبيق ؟',
                  style: Theme.of(context).textTheme.headline6),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('لا',
                      style: TextStyle(
                          color: MainColor.yellowColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('نعم',
                      style: TextStyle(
                          color: MainColor.yellowColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    option = Provider.of<OptionProvider>(context, listen: false);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: IconButton(
                          onPressed: () =>
                              Get.to(() => const PrintOfficeWorkingHours()),
                          icon: Icon(
                            Icons.power_settings_new,
                            color: MainColor.darkGreyColor,
                            size: 30,
                          )),
                    ),
                  ],
                  leading: IconButton(
                    onPressed: _handleMenuButtonPressed,
                    icon: ValueListenableBuilder<AdvancedDrawerValue>(
                      valueListenable: option!.advancedDrawerController,
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
                  centerTitle: true,
                  title: Text(
                    'الصفحة الرئيسية',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(right: 12, top: 30, left: 12),
                  child: ListView(
                    children: [
                      Text(
                        '${UserSharedPreferences.getPrintOfficeName()}',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Stack(
                        children: [
                          Row(
                            children: [
                              Text(
                                '(0)',
                                style: TextStyle(
                                    color: MainColor.darkGreyColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                              const RatingBuilder(
                                rating: 0,
                                itemSize: 18,
                              ),
                              const SizedBox(
                                child: Text(
                                  'kkkkkkkkkkkk',
                                  style: TextStyle(color: Colors.transparent),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 21,
                            color: MainColor.darkGreyColor,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.6,
                            child: Text(
                              '${UserSharedPreferences.getPrintOfficeAddress()}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14, bottom: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.3,
                              height: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => Text(
                                      '${orderController.order.length + orderController.completedOrderList.length}',
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                  ),
                                  Text(
                                    'إجمالي الطلبات',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.26,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  (UserSharedPreferences.getUserAvatarUrl() !=
                                          null)
                                      ? UserSharedPreferences
                                          .getUserAvatarUrl()!
                                      : 'https://firebasestorage.googleapis.com/v0/b/printore-2364c.appspot.com/o/vz5KFq5YWxRT7HqZkSw1gm2LAu02%2Fprofile%2Fcamera.png?alt=media&token=88a3a37c-f351-4278-bcff-aaf95b54b8f2',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _drawOrderButton(
                                textTitle: 'الطلبات المنتظرة',
                                noOfOrders:
                                    orderController.order.length.toString(),
                                icon: Icons.format_list_bulleted_rounded),
                            _drawOrderButton(
                                textTitle: 'الطلبات المكتملة',
                                noOfOrders: orderController
                                    .completedOrderList.length
                                    .toString(),
                                icon: Icons.playlist_add_check_rounded),
                          ],
                        ),
                      )
                    ],
                  ),
                ))));
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    option!.advancedDrawerController.value = AdvancedDrawerValue.visible();
    option!.advancedDrawerController.showDrawer();
  }

  Widget _drawOrderButton(
      {required String textTitle,
      required String noOfOrders,
      required IconData icon}) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      height: 120,
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 8,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ]),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    noOfOrders,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(icon, color: MainColor.darkGreyColor, size: 33)
                ],
              ),
              Text(
                textTitle,
                style: Theme.of(context).textTheme.headline4,
              )
            ]),
      ),
    );
  }
}
