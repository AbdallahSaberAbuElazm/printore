import 'package:firebase_storage/firebase_storage.dart';

class GetImageFirebase {
  Future getData(String url) async {
    return await FirebaseStorage.instance.refFromURL(url).getDownloadURL();
  }
}
