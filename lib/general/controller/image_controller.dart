import 'dart:io';

import 'package:app/general/model/image.dart';
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

  static Future<UploadedImage> uploadImage({
    required File imageFile,
    required String category,
    required String docID,
    bool isNewsGallery = false,
  }) async {
    UploadedImage uploadedImage = UploadedImage(imageURL: '', imagePath: '');
    String imageExtenstion = path.extension(imageFile.path);
    final ref = isNewsGallery
        ? FirebaseStorage.instance
            .ref()
            .child('images')
            .child(category)
            .child(docID)
            .child('album')
            .child('${Timestamp.now().microsecondsSinceEpoch}$imageExtenstion')
        : FirebaseStorage.instance
            .ref()
            .child('images')
            .child(category)
            .child(docID)
            .child('$docID$imageExtenstion');

    await ref.putFile(imageFile);
    uploadedImage.imageURL = await ref.getDownloadURL();
    uploadedImage.imagePath = ref.fullPath;
    return uploadedImage;
  }
}
