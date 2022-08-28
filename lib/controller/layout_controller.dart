import 'package:get/get.dart';
import 'package:printore/model/product/option/layout.dart';
import 'package:printore/services/firestore_db.dart';

class LayoutController extends GetxController {
  final list = <Layout>[].obs;
  RxString optionNameSelected = 'قائم'.obs;
  static RxInt count = 1.obs;
  static var sharedLayoutSelected = 'قائم'.obs;
  final layoutPrice = 0.0.obs;
  final layoutNumber = 0.obs;

  static void updateCount(int countData) {
    count.value = countData;
  }

  @override
  void onInit() {
    list.bindStream(FirestoreDB().getLayouts());
    super.onInit();
  }

  void updateOptionName(String layoutName) {
    optionNameSelected.value = layoutName;
    sharedLayoutSelected.value = layoutName;
    update();
  }

  updateOptionPrice(double price) {
    layoutPrice.value = price;
    update();
  }

  updateNoOfPagesInLayout(int numberOfPages) {
    layoutNumber.value = numberOfPages;
    update();
  }
}
