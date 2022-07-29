import 'package:get/get.dart';
import 'package:printore/model/product/option/paper_type.dart';
import 'package:printore/services/firestore_db.dart';

class PaperTypeController extends GetxController {
  final list = <PaperType>[].obs;
  RxString optionNameSelected = 'عادي'.obs;

  @override
  void onInit() {
    list.bindStream(FirestoreDB().getPaperTypes());
    super.onInit();
  }

  void updateOptionName(String paperType) {
    optionNameSelected.value = paperType;
    update();
  }
}
