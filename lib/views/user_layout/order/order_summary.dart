import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/controller/cart_controller.dart';
import 'package:printore/controller/order_controller.dart';
import 'package:printore/controller/print_officce_controller.dart';
import 'package:printore/model/order/order.dart';
import 'package:printore/views/shared/constant/constant.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:printore/views/shared/widgets/button_center_button.dart';
import 'package:printore/views/shared/widgets/rating_builder.dart';
import 'package:printore/views/user_layout/cart/cart_items.dart';
import 'package:printore/views/user_layout/profile/determine_address.dart';
import 'package:printore/views/user_layout/qr_code/qr_code_user.dart';

class OrderSummary extends StatelessWidget {
  // PrintOffice printOffice;
  OrderSummary({
    Key? key,
    //  required this.printOffice
  }) : super(key: key);

  final _style = TextStyle(
      color: MainColor.darkGreyColor,
      fontSize: 12,
      fontWeight: FontWeight.w500);
  final CartController _cartController = Get.find();
  final PrintOfficeController _printOfficeController = Get.find();
  final OrderController _orderController = Get.find<OrderController>();
  final User? user = FirebaseAuth.instance.currentUser;
  final List<String> cartIds = [];
  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            backgroundColor: MainColor.darkGreyColor,
            title: Styles.appBarText('مراجعة طلب الطباعة', context),
            centerTitle: true,
            leading: const SizedBox.shrink(),
            actions: [
              Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    onPressed: () => Get.off(() => const DetermineAddress()),
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 26,
                    ),
                  )),
            ],
          ),
          bottomSheet: BottomCenterButton(
            buttonTitle: 'إستمرار',
            onPressed: () {
              Get.to(() => QRCodeUser());
              _orderController.sendOrder(
                  order: Order(
                      orderId: '',
                      printOfficeId: _printOfficeController.printOffice[0].id,
                      customerId: user!.uid,
                      qrCode:
                          '${Constant.user!.uid}${UserSharedPreferences.getUserName()}',
                      cartIds: cartIds,
                      deliveryFee: 0.0,
                      total: 0.0,
                      subTotal: 0.0,
                      isAccepted: false,
                      isCancelled: false,
                      isDeliverd: false,
                      createdAt: Styles.now.toString()),
                  printOfficeId:
                      _printOfficeController.printOffice[0].id.toString());
              for (String id in cartIds) {
                _orderController.updateCartOrderd(id);
              }
            },
            actionRelated: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(children: [
                _drawStepper(context),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Styles.drawStepperNameRow(context: context),
                ),
                _drawOrderList(),
                _drawPrice(context: context),
                _drawCoupon(context: context),
                _serviceProvider(context: context),
                const SizedBox(
                  height: 60,
                )
              ]),
            ),
          )),
    );
  }

  // draw stepper
  Widget _drawStepper(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 24, right: 12, left: 12),
        child: Row(
          children: [
            Styles.drawContainerOfStepper(color: MainColor.yellowColor),
            Styles.drawLineOfStepper(
                color: MainColor.yellowColor, context: context),
            Styles.drawContainerOfStepper(
              color: MainColor.yellowColor,
            ),
            Styles.drawLineOfStepper(
                color: MainColor.yellowColor, context: context),
            Styles.drawContainerOfStepper(
              color: MainColor.yellowColor,
            ),
          ],
        ));
  }

  Widget _drawOrderList() {
    return ListView.builder(
      shrinkWrap: true,
      // primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cartController.cart.length,
      itemBuilder: (context, index) {
        final price = _cartController.cart[index].numPages! * 4 * 0.5;

        _cartController.updatePrice(price);
        cartIds.add(_cartController.cart[index].cartId.toString());

        return CartItems(
          index: index,
          summary: true,
          map: _cartController.cart,
        );
      },
    );
  }

  Widget _drawPrice({required BuildContext context}) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(right: 12, left: 12),
      margin: const EdgeInsets.only(right: 12, left: 12, top: 2, bottom: 10),
      decoration: BoxDecoration(
          color: MainColor.darkGreyColor,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 8,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text(
          'المبلغ الكلي',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            children: const [
              Text(
                '0.0',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  'جنيه',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget _drawCoupon({required BuildContext context}) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(right: 12, left: 12),
      margin: const EdgeInsets.only(right: 12, left: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 8,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ]),
      child: Row(children: [
        Container(
          height: 27,
          width: 50,
          decoration: BoxDecoration(
            color: MainColor.yellowColor,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: Center(
            child: Text(
              'تفعيل',
              style: TextStyle(color: MainColor.darkGreyColor, fontSize: 10),
            ),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: TextField(
              style: TextStyle(
                color: MainColor.darkGreyColor,
              ),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MainColor.darkGreyColor)),
                hintText: ' ادخل كود الخصم',
                hintStyle:
                    TextStyle(color: MainColor.darkGreyColor, fontSize: 11),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _serviceProvider({required BuildContext context}) {
    return Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 17, top: 22),
        padding: const EdgeInsets.only(left: 16),
        //  height: 120,
        width: double.infinity,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 65,
                  height: 150,
                  decoration: BoxDecoration(
                      color: MainColor.darkGreyColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12))),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.print_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        Text(
                          'مقدم الخدمة',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ]),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.only(right: 12, left: 8, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_printOfficeController.printOffice[0].printOfficeName}',
                        style: _style,
                      ),
                      SizedBox(
                        child: Text(
                          '${_printOfficeController.printOffice[0].printOfficeAddress}',
                          // maxLines: 2,
                          style: _style,
                        ),
                      ),
                      Stack(
                        children: [
                          Row(
                            children: [
                              Text(
                                '(${_printOfficeController.printOffice[0].printOfficeRating})',
                                style: TextStyle(
                                    color: MainColor.darkGreyColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              RatingBuilder(
                                rating: _printOfficeController
                                    .printOffice[0].printOfficeRating!
                                    .toDouble(),
                                itemSize: 18,
                              ),
                            ],
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
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 68,
                  height: 75,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      '${_printOfficeController.printOffice[0].printOfficeUrl}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  'خلال 15 دقيقة',
                  style: TextStyle(
                      color: MainColor.darkGreyColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700),
                ),
              ],
            )
          ],
        ));
  }
}
