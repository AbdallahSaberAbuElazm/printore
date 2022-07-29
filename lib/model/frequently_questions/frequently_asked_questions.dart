import 'package:cloud_firestore/cloud_firestore.dart';

class FrequentlyAskedQuestions {
  String? questionName;
  String? questionAnswer;

  FrequentlyAskedQuestions(
      {required this.questionName, required this.questionAnswer});

  static FrequentlyAskedQuestions fromSnapShot(DocumentSnapshot snapshot) {
    FrequentlyAskedQuestions frequentlyAskedQuestions =
        FrequentlyAskedQuestions(
            questionName: snapshot['questionName'],
            questionAnswer: snapshot['questionAnswer']);
    return frequentlyAskedQuestions;
  }

  Map<String, dynamic> toMap() {
    return {
      'questionName': questionName,
      'questionAnswer': questionAnswer,
    };
  }
}
