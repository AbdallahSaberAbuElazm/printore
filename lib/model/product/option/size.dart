import 'package:cloud_firestore/cloud_firestore.dart';

class Size {
  final String optionName;
  // final String downloadUrl;

  const Size({
    required this.optionName,
    //  required this.downloadUrl
  });

  static Size fromSnapShot(DocumentSnapshot snapshot) {
    Size size = Size(
      optionName: snapshot['sizeName'],
      //  downloadUrl: snapshot['downloadUrl']
    );
    return size;
  }

  Map<String, dynamic> toMap() {
    return {
      'sizeName': optionName,
      //  'downloadUrl': downloadUrl
    };
  }
}
