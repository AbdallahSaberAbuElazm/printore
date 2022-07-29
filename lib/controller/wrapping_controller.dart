import 'package:get/get.dart';
import 'package:printore/model/product/option/wrapping.dart';
import 'package:printore/services/firestore_db.dart';

class WrappingController extends GetxController {
  final list = <Wrapping>[].obs;

  var optionNameSelected = 'بدون تغليف'.obs;

  @override
  void onInit() {
    list.bindStream(FirestoreDB().getWrapping());
    super.onInit();
  }

  void updateOptionName(String sizeName) {
    optionNameSelected.value = sizeName;
    update();
  }
}
