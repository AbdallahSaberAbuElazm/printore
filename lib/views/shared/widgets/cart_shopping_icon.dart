import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printore/controller/cart_controller.dart';
import 'package:printore/views/shared/styles/colors.dart';
import 'package:printore/views/user_layout/cart/cart_screen.dart';

class CartShoppingIcon extends StatelessWidget {
  CartShoppingIcon({Key? key}) : super(key: key);
  final CartController _cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 150.0,
            width: 30.0,
            child: Stack(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: MainColor.yellowColor,
                  ),
                  onPressed: () => (_cartController.cart.isNotEmpty)
                      ? Get.to(() => CartScreen())
                      : null,
                ),
                _cartController.cart.isEmpty
                    ? Container()
                    : Transform.translate(
                        offset: const Offset(-1, -6),
                        child: Stack(
                          children: <Widget>[
                            const Icon(Icons.brightness_1,
                                size: 18.0, color: Colors.white),
                            Positioned(
                                top: -1,
                                right: 6.0,
                                bottom: -0.3,
                                child: Center(
                                  child: Text(
                                    _cartController.cart.length.toString(),
                                    style: TextStyle(
                                        color: MainColor.darkGreyColor,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ],
                        )),
              ],
            ),
          )),
    );
  }
}
