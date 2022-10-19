import 'dart:io';

import 'package:app/controller/image_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
    String imageURL = await ImageController.uploadImage(
        imageFile: pickedImage.value, category: 'news');
    await FirebaseFirestore.instance.collection('news').add(
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
}
