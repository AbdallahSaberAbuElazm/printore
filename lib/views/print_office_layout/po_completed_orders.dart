import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:printore/controller/order_controller.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/services/firestore_db.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'dart:math' as math;
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:provider/provider.dart';

class PrintOfficeCompletedOrders extends StatefulWidget {
  const PrintOfficeCompletedOrders({Key? key}) : super(key: key);

  @override
  State<PrintOfficeCompletedOrders> createState() =>
      _PrintOfficeCompletedOrdersState();
}

class _PrintOfficeCompletedOrdersState
    extends State<PrintOfficeCompletedOrders> {
  // int pageCount = 0;
  OptionProvider? option;
  OrderController orderController = Get.find();
  DocumentSnapshot<Map<String, dynamic>>? user;
  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    option = Provider.of<OptionProvider>(context, listen: false);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Icon(
                    Icons.power_settings_new,
                    color: MainColor.darkGreyColor,
                    size: 30,
                  ),
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
                'الطلبات المكتملة',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 15),
                child: _drawCustomerOrder())));
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    option!.advancedDrawerController.value = AdvancedDrawerValue.visible();
    option!.advancedDrawerController.showDrawer();
  }

  Widget _drawCustomerOrder() {
    return Obx(
      () => ListView.builder(
          itemCount: orderController.completedOrderList.length,
          itemBuilder: (context, index) {
            getSpecificUser(
                userId: orderController.completedOrderList[index].customerId
                    .toString());
            return Container(
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 241, 241),
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
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: MainColor.yellowColor,
                      backgroundImage: NetworkImage((user != null)
                          ? user!["avatarUrl"]
                          : UserSharedPreferences.getUserAvatarUrl()!),
                      radius: 32,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(user != null) ? user!["first_name"] : ""} ${(user != null) ? user!["last_name"] : ""}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Row(
                          children: [
                            Transform.rotate(
                                angle: 180 * math.pi / 135,
                                child: const Icon(
                                  Icons.attach_file,
                                  size: 15,
                                )),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              '${orderController.completedOrderList[index].cartIds!.length} ملف',
                              style: TextStyle(
                                  color: MainColor.darkGreyColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'رقم الطلب 1',
                      style: TextStyle(
                          color: MainColor.darkGreyColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ));
          }),
    );
  }

  getSpecificUser({required String userId}) async {
    final data = await FirestoreDB().getSpecificUser(userId: userId);
    if (!mounted || user == null) {
      setState(() {
        user = data;
      });
    }
  }
}
