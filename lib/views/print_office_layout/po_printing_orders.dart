import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:printore/controller/order_controller.dart';
import 'package:printore/model/cart/cart.dart';
import 'package:printore/model/order/order.dart';
import 'package:printore/provider/option_provider.dart';
import 'package:printore/services/firestore_db.dart';
import 'package:printore/views/print_office_layout/po_finish_printing.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:provider/provider.dart';

class PrintOfficePrintingOrders extends StatefulWidget {
  const PrintOfficePrintingOrders({Key? key}) : super(key: key);

  @override
  State<PrintOfficePrintingOrders> createState() =>
      _PrintOfficePrintingOrdersState();
}

class _PrintOfficePrintingOrdersState extends State<PrintOfficePrintingOrders> {
  int indexSelected = 0;
  int pageCount = 0;
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
                'طلبات الطباعة',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 18, top: 15),
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
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
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.4,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        indexSelected = 0;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          'اليوم',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        (indexSelected == 0)
                                            ? _expandedSelectedPrintOffice()
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  color: MainColor.darkGreyColor,
                                  width: 1,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.4,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        indexSelected = 1;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          'كل الأيام',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        (indexSelected == 1)
                                            ? _expandedSelectedPrintOffice()
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        _drawCustomerOrder()
                      ]),
                ),
              ),
            )));
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    option!.advancedDrawerController.value = AdvancedDrawerValue.visible();
    option!.advancedDrawerController.showDrawer();
  }

  //draw line under selected option
  Widget _expandedSelectedPrintOffice() {
    return Expanded(
        child: Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        height: 4,
        width: MediaQuery.of(context).size.width / 4,
        color: MainColor.darkGreyColor,
      ),
    ));
  }

  Widget _drawCustomerOrder() {
    return Obx(
      () => ListView.builder(
          shrinkWrap: true,
          // primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orderController.order.length,
          itemBuilder: (context, index) {
            getSpecificUser(
                userId: orderController.order[index].customerId.toString());

            return InkWell(
              onTap: () {
                Get.to(() => PrintOfficeFinishPrinting(
                      user: user!,
                      order: orderController.order[index],
                    ));
                orderController.cartOrder.clear();
                getSpecificCart(
                    userId: user!.id, order: orderController.order[index]);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, top: 15),
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
                        ],
                      ),
                      subtitle: Text(
                        'رقم الطلب 1',
                        style: TextStyle(
                            color: MainColor.darkGreyColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                      trailing: Icon(
                        Icons.forward,
                        color: MainColor.darkGreyColor,
                        size: 30,
                      )),
                ),
              ),
            );
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

  getSpecificCart({required String userId, required Order order}) async {
    for (String cartId in order.cartIds!) {
      orderController.getCartOrder(Cart.fromSnapShot(
          await FirestoreDB().getSpecificCart(userId: userId, cartId: cartId)));
    }
  }
}
