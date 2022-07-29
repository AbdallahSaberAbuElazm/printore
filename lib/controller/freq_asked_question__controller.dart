import 'package:get/get.dart';
import 'package:printore/model/frequently_questions/frequently_asked_questions.dart';

import 'package:printore/services/firestore_db.dart';

class FrequentlyAskedQuestionController extends GetxController {
  final frequentlyAskedQuestions = <FrequentlyAskedQuestions>[].obs;

  @override
  void onInit() {
    frequentlyAskedQuestions.bindStream(FirestoreDB().getFrequenltyQuestions());
    super.onInit();
  }
}
