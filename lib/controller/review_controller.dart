import 'package:get/get.dart';

class ReviewController extends GetxController {
  RxDouble newRating = 0.0.obs;

  updateNewRating(double rating) {
    newRating.value = rating;
  }
}
