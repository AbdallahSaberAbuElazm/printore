import 'package:cloud_firestore/cloud_firestore.dart';

class OptionApi {
  final CollectionReference _collectionRefSize =
      FirebaseFirestore.instance.collection('sizes');

  Future<List<Object?>> getDataSize() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRefSize.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }
}
