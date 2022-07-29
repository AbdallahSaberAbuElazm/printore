import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printore/provider/option_provider.dart';
import 'package:printore/views/shared/styles/styles.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:printore/views/shared/util/util.dart';
import 'package:pdf/pdf.dart';

class PickMultiFiles {
  FilePickerResult? result;
  List<File>? _files;
  OptionProvider? option;
  List<UploadTask>? taskSnapshot = <UploadTask>[];
  PlatformFile? platformFile;
  User? user = FirebaseAuth.instance.currentUser;
  final pdf = pw.Document();
  final ImagePicker _picker = ImagePicker();
// get multi files
  Future getPdfAndUpload(BuildContext context) async {
    result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'png',
        'jpg',
      ],
    );
    if (result != null) {
      showDialog(
          context: context,
          builder: (context) => Styles.alertUploadFile(
              context: context,
              uploadFile: () async {
                Navigator.pop(context);
                Navigator.pop(context);
                EasyLoading.init();
                _files = result!.paths.map((path) => File(path!)).toList();

                try {
                  for (var file in _files!) {
                    EasyLoading.show(
                      status: '... جاري التحميل',
                    );
                    if (extension(file.path) != '.pdf') {
                      final image = pw.MemoryImage(file.readAsBytesSync());
                      pdf.addPage(pw.Page(
                          pageFormat: PdfPageFormat.a4,
                          build: (pw.Context context) {
                            return pw.Center(child: pw.Image(image));
                          }));
                    } else {
                      uploadFile(file);
                    }
                  }

                  final output = await getTemporaryDirectory();
                  final pdfFile = File(
                      "${output.path}/${UserSharedPreferences.getUserName()}.pdf");
                  // final doc = await PDFDoc.fromFile(pdfFile);

                  await pdfFile.writeAsBytes(await pdf.save());
                  uploadFile(pdfFile);
                } on FirebaseException catch (e) {
                  return Utils.snackBar(context: context, msg: e.message);
                }
              }));
    } else {
      Navigator.pop(context);
    }
  }

  uploadFile(File file) async {
    String fileName = basename(file.path);
    if (fileName.length > 45) {
      fileName = fileName.substring(1, 40);
    }

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    UploadTask taskSnapshot = FirebaseStorage.instance
        .ref('${user!.uid}/files/${Utils.createCryptoRandomString(2)}$fileName')
        .putFile(file);
    final int numPages;
    if (extension(file.path) == '.pdf') {
      final doc = await PDFDoc.fromFile(file);
      numPages = doc.length;
    } else {
      numPages = 1;
    }
    final url = await (await taskSnapshot).ref.getDownloadURL();

    var data = {
      'downloadUrl': url,
      'file_name': fileName,
      'numPages': numPages,
      'file_extension': extension(file.path),
      'customer': user!.uid,
      'upload_at': Styles.formattedDate,
    };
    await firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .collection('files')
        .add(data);
    EasyLoading.showToast('تم التحميل بنجاح',
        toastPosition: EasyLoadingToastPosition.bottom);
    EasyLoading.dismiss();
  }

// get camera image
  Future getCameraImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      EasyLoading.show(
        status: '... جاري التحميل',
      );
      final file = File(image.path);
      final img = pw.MemoryImage(file.readAsBytesSync());
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(img));
          }));
      final output = await getTemporaryDirectory();
      final pdfFile =
          File("${output.path}/${UserSharedPreferences.getUserName()}.pdf");
      await pdfFile.writeAsBytes(await pdf.save());
      try {
        uploadFile(pdfFile);
      } on FirebaseException catch (e) {
        return Utils.snackBar(context: context, msg: e.message);
      }
    }
  }
}
