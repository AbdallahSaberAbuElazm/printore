import 'package:get/get.dart';
import 'package:printore/model/review/review.dart';
import 'package:printore/services/firestore_db.dart';

class ReviewController extends GetxController {
  final list = <Review>[].obs;
  RxDouble newRating = 0.0.obs;

  updateNewRating(double rating) {
    newRating.value = rating;
    update();
  }

  uploadReview({required Map<String, dynamic> toMap}) {
    FirestoreDB().uploadReview(toMap: toMap);
  }
}
