import 'package:get/get.dart';
import 'package:printore/model/product/option/wrapping.dart';
import 'package:printore/services/firestore_db.dart';

class WrappingController extends GetxController {
  final list = <Wrapping>[].obs;

  var optionNameSelected = 'بدون تغليف'.obs;
  final wrappingPrice = 0.0.obs;

  @override
  void onInit() {
    list.bindStream(FirestoreDB().getWrapping());
    super.onInit();
  }

  void updateOptionName(String wrapping) {
    optionNameSelected.value = wrapping;
    update();
  }

  updateOptionPrice(double price) {
    wrappingPrice.value = price;
    update();
  }
}
