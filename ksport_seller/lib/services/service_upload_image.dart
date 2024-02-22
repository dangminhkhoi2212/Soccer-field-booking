import 'dart:io';

import 'package:ksport_seller/utils/util_snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageService {
  final storage = FirebaseStorage.instance;

  Future<String?> uploadImage(
      {required XFile file, required String folder}) async {
    try {
      File image = File(file.path);
      final fileType = image.path.split('.').last.toLowerCase();
      final reference = storage.ref().child('$folder/${file.name}');
      final metaData = SettableMetadata(contentType: 'image/$fileType');
      await reference.putFile(
          File(
            file.path,
          ),
          metaData);
      final String imageUrl = await reference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      SnackbarUtil.getSnackBar(
          title: 'Upload avatar',
          message: 'Have an occur error. Please try again');
    }
    return null;
  }
}
