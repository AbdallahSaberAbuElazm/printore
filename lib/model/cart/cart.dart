import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String? cartId;
  String? fileId;
  String? fileName;
  String? downloadUrl;
  String? customerId;
  int? numPages;
  int noOfCopies = 1;
  String? fileExtension;
  String? uploadAt;
  late String optionSize;
  late String optionPaperType;
  late String optionColor;
  late String optionSide;
  late String optionLayout;
  late String optionWrapping;
  String? optionNote;
  bool? ordered;
  bool? finished = false;
  Cart(
      {required this.cartId,
      required this.optionSize,
      required this.optionPaperType,
      required this.optionColor,
      required this.optionSide,
      required this.optionLayout,
      required this.optionWrapping,
      required this.optionNote,
      required this.fileId,
      required this.fileName,
      required this.downloadUrl,
      required this.customerId,
      required this.numPages,
      required this.noOfCopies,
      required this.fileExtension,
      required this.uploadAt,
      required this.ordered,
      required this.finished});

  static Cart fromSnapShot(DocumentSnapshot jsonObject) {
    return Cart(
        cartId: jsonObject.id,
        optionSize: jsonObject['optionSize'],
        optionPaperType: jsonObject['optionPaperType'],
        optionColor: jsonObject['optionColor'],
        optionSide: jsonObject['optionSide'],
        optionLayout: jsonObject['optionLayout'],
        optionWrapping: jsonObject['optionWrapping'],
        optionNote: jsonObject['optionNote'],
        fileId: jsonObject['fileId'],
        fileName: jsonObject['file_name'],
        downloadUrl: jsonObject['downloadUrl'],
        customerId: jsonObject['customer'],
        numPages: jsonObject['numPages'],
        noOfCopies: jsonObject['noOfCopies'],
        fileExtension: jsonObject['file_extension'],
        uploadAt: jsonObject['upload_at'],
        ordered: jsonObject['ordered'],
        finished: jsonObject['finished']);
  }

  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId,
      'optionSize': optionSize,
      'optionPaperType': optionPaperType,
      'optionColor': optionColor,
      'optionSide': optionSide,
      'optionLayout': optionLayout,
      'optionWrapping': optionWrapping,
      'optionNote': optionNote,
      'fileId': fileId,
      'file_name': fileName,
      'downloadUrl': downloadUrl,
      'numPages': numPages,
      'noOfCopies': noOfCopies,
      'file_extension': fileExtension,
      'customer': customerId,
      'upload_at': uploadAt,
      'ordered': ordered,
      'finished': finished
    };
  }
}
