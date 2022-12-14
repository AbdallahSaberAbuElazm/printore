import 'package:get/get.dart';
import 'package:printore/model/cart/cart.dart';
import 'package:printore/model/order/order.dart';
import 'package:printore/services/firestore_db.dart';

class OrderController extends GetxController {
  final order = <Order>[].obs;
  final completedOrderList = <Order>[].obs;
  final userOrderList = <Order>[].obs;
  final cartOrder = <Cart>[].obs;
  final noOfFileQrCode = 0.0.obs;

  @override
  void onInit() {
    order.bindStream(FirestoreDB().getPrintOfficerOrders());
    completedOrderList
        .bindStream(FirestoreDB().getPrintOfficerCompletedOrders());
    userOrderList.bindStream(FirestoreDB().getUserOrders());
    super.onInit();
  }

  getCartOrder(Cart cart) {
    cartOrder.add(cart);
    update();
  }

  sendOrder({required Order order, required String printOfficeId}) {
    FirestoreDB().setOrders(order: order, printOfficeId: printOfficeId);
    update();
  }

  updateCartOrderd(String id) {
    FirestoreDB().updateCartOrdered(cartId: id);
  }

  int checkQrCode(String barcode) {
    int x = 0;

    for (int i = 0; i < completedOrderList.length; i++) {
      if (barcode == completedOrderList[i].qrCode) {
        noOfFileQrCode.value +=
            int.parse(completedOrderList[i].cartIds!.length.toString());
        x++;
        completedOrderList[i].isDeliverd = true;

        FirestoreDB().updateDeliverdOrders(
            barcode: barcode,
            orderId: completedOrderList[i].orderId.toString(),
            customerId: completedOrderList[i].customerId.toString(),
            toMap: completedOrderList[i].toMap());
        // update();
      }
    }
    return x;
  }
}
