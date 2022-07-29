import 'package:cloud_firestore/cloud_firestore.dart';

class Layout {
  final String optionName;
  final String downloadUrl;

  Layout({required this.optionName, required this.downloadUrl});

  static Layout fromSnapShot(DocumentSnapshot snapshot) {
    Layout layout = Layout(
      optionName: snapshot['layout_name'],
      downloadUrl: snapshot['downloadUrl'],
    );
    return layout;
  }
}
