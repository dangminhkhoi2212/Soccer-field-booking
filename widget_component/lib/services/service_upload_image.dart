import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImageService {
  final storage = FirebaseStorage.instance;

  Future<String?> uploadImage(
      {required dynamic file, required String folder}) async {
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
      debugPrint(e.toString());
    }
    return null;
  }
}
