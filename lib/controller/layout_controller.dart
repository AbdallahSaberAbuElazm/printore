import 'package:get/get.dart';
import 'package:printore/model/product/option/layout.dart';
import 'package:printore/services/firestore_db.dart';

class LayoutController extends GetxController {
  final list = <Layout>[].obs;
  RxString optionNameSelected = 'قائم'.obs;
  static RxInt count = 1.obs;
  static var sharedLayoutSelected = 'فائم'.obs;

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
}
