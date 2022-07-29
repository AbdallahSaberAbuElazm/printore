import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:printore/views/shared/constant/constant.dart';
import 'package:printore/views/shared/util/user_shared_preferences.dart';
import 'package:printore/views/shared/util/util.dart';

class UploadImageProfile {
  static final ImagePicker _picker = ImagePicker();
  static Future<Map<String, dynamic>> uploadImageProfile(
      {required BuildContext context}) async {
    String url = '';
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      try {
        if (UserSharedPreferences.getUserAvatarUrl() != null) {
          FirebaseStorage.instance
              .ref(
                  '${Constant.user!.uid}/profile/${UserSharedPreferences.getUserAvatarName()}')
              .delete();
        }
        var taskSnapshot = FirebaseStorage.instance
            .ref('${Constant.user!.uid}/profile/${basename(image.path)}')
            .putFile(file);
        url = await (await taskSnapshot).ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection('users')
            .doc(Constant.user!.uid)
            .update({'avatarUrl': url});
      } on FirebaseException catch (e) {
        return Utils.snackBar(context: context, msg: e.message);
      }
    }
    return {'url': url, 'avatarName': image!.path};
  }
}
