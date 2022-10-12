import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../widgets/navigator_page.dart';

class NewsController extends GetxController {
  final isLoading = false.obs;
  final pickedImage = File('').obs;
  final ImagePicker picker = ImagePicker();

  Future<void> addNews({
    required String title,
    required String shortDesc,
    required String description,
    required String category,
  }) async {
    isLoading.value = true;
    String imageURL = await uploadImage(imageFile: pickedImage.value);
    await FirebaseFirestore.instance.collection('news').doc().set(
      {
        'title': title,
        'subTitle': shortDesc,
        'description': description,
        'category': category,
        'timestamp': FieldValue.serverTimestamp(),
        'imageURL': imageURL,
      },
    ).then((value) {
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'تم إضافة الفرصة بنجاح');
      Get.offAll(
        () => NavigatorPage(tabIndex: 2),
        duration: const Duration(microseconds: 1),
      );
    }).catchError((e) {
      print('error on submitting the news $e');
      isLoading.value = false;
    });
  }

  Future<void> pickImage() async {
    try {
      final XFile? imageFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 17,
      );
      pickedImage.value = File(imageFile!.path);
    } catch (e) {
      print('error in image picking $e');
    }
  }

  Future<String> uploadImage({required File imageFile}) async {
    String imageExtenstion = path.extension(imageFile.path);
    final ref = FirebaseStorage.instance.ref().child('images').child('news').child(
        '${Timestamp.now().millisecondsSinceEpoch.toString()}$imageExtenstion');
    await ref.putFile(imageFile);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }
}
