import 'package:get/get.dart';
import 'package:printore/model/product/option/side.dart';
import 'package:printore/services/firestore_db.dart';

class SideColorController extends GetxController {
  final list = <Side>[].obs;
  final side = 'وجه واحد'.obs;
  final priceSide = 0.0.obs;
  final noOfSide = 0.obs;
  final color = 'أبيض-أسود'.obs;

  @override
  void onInit() {
    list.bindStream(FirestoreDB().getSide());
    super.onInit();
  }

  void updateOptionSide(String sideName) {
    side.value = sideName;
    update();
  }

  getPriceSide(double price) {
    priceSide.value = price;
    update();
  }

  void updateOptionColor(String colorName) {
    color.value = colorName;
    update();
  }

  getNoOfSide(int side) {
    noOfSide.value = side;
    update();
  }
}
