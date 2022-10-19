import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ImageController {
  static ImagePicker picker = ImagePicker();

  static Future<File> pickImage({int imageQuality = 17}) async {
    try {
      final XFile? imageFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
      );
      return File(imageFile!.path);
    } catch (e) {
      print('error in image picking $e');
      return File('');
    }
  }

  static Future<String> uploadImage({
    required File imageFile,
    required String category,
  }) async {
    String imageExtenstion = path.extension(imageFile.path);
    final ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(category)
        .child(
            '${Timestamp.now().millisecondsSinceEpoch.toString()}$imageExtenstion');
    await ref.putFile(imageFile);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }
}
