import 'package:get/get.dart';
import 'package:printore/model/product/option/paper_price.dart';
import 'package:printore/services/firestore_db.dart';

class PaperPriceController extends GetxController {
  final paperPrice = <PaperPrice>[].obs;

  getPaperPrice(
      {required String paperSize,
      required String paperType,
      required String paperColor}) {
    paperPrice.bindStream(FirestoreDB().getPaperPrice(
        paperSize: paperSize, paperType: paperType, paperColor: paperColor));

    update();
  }
}
