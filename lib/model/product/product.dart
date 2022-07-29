import 'package:printore/model/product/file_model.dart';
import 'package:printore/model/product/option/option.dart';

class Product {
  FileModel? file;
  OptionModel? option;
  int? noOfCopies;

  Product({required this.file, required this.option, required this.noOfCopies});

  Map<String, dynamic> toMap() {
    return {
      'file': file,
      'option': option,
    };
  }
}
