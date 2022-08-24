import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/controller/cart_controller.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/check_internet_connection.dart';
import 'package:printore/views/shared/widgets/button_center_button.dart';
import 'package:printore/views/shared/widgets/cart_shopping_icon.dart';
import 'package:printore/views/user_layout/cart/cart_items.dart';
import 'package:printore/views/user_layout/home/home.dart';
import 'package:printore/views/user_layout/home/upload_page.dart';
import 'package:printore/views/user_layout/select_library/locating.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);
  final User? user = FirebaseAuth.instance.currentUser;
  final CartController _cartController = Get.find();
  @override
  Widget build(BuildContext context) {
    CheckInternetConnection.CheckUserConnection(context: context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Obx(() => Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: MainColor.darkGreyColor,
              title: Styles.appBarText('سلة مطبوعاتك', context),
              centerTitle: true,
              leading: CartShoppingIcon(),
              actions: [
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      onPressed: () => Get.to(() => Home(
                          recentPage: const UploadPage(), selectedIndex: 2)),
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 26,
                      ),
                    )),
              ],
            ),
            bottomSheet: BottomCenterButton(
              buttonTitle: 'الدفع',
              onPressed: () => Get.to(() => const Locating()),
              actionRelated: true,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: MainColor.yellowColor,
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      onPressed: () => Get.off(Home(
                        recentPage: const UploadPage(),
                        selectedIndex: 2,
                      )),
                      tooltip: "تحميل ملف",
                      child: Center(
                        child: Icon(
                          Icons.file_upload,
                          color: MainColor.darkGreyColor,
                          size: 34,
                        ),
                      ),
                      elevation: 4.0,
                    ),
                  ),
                )),
            body: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.22,
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: _cartController.cart.length,
                      itemBuilder: (context, index) {
                        return CartItems(
                          index: index,
                          summary: false,
                          map: _cartController.cart,
                        );
                      }),
                )))));
  }
}
