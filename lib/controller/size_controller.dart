import 'package:get/get.dart';
import 'package:printore/model/product/option/size.dart';
import 'package:printore/services/firestore_db.dart';

class SizeController extends GetxController {
  //Add a list of product objects
  final list = <Size>[].obs;
  var optionNameSelected = 'A5'.obs;
  static var sharedSizeSelected = 'A5'.obs;

  @override
  void onInit() {
    list.bindStream(FirestoreDB().getSizes());

    super.onInit();
  }

  void updateOptionName(String sizeName) {
    optionNameSelected.value = sizeName;
    sharedSizeSelected.value = sizeName;
    update();
  }
}
