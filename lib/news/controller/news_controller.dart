import 'dart:io';

import 'package:app/general/model/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../general/controller/image_controller.dart';
import '../../widgets/navigator_page.dart';
import '../model/news.dart';

class NewsController extends GetxController {
  final isLoading = false.obs;
  final pickedImage = File('').obs;
  final ImagePicker picker = ImagePicker();

  Future<void> addModifyNews({
    required News news,
    bool isModifing = false,
    bool isPicChanged = false,
  }) async {
    isLoading.value = true;

    Map<String, dynamic> newsData = {
      'title': news.title,
      'subTitle': news.subTitle,
      'description': news.description,
      'category': news.category,
      'timestamp': isModifing ? news.timestamp : FieldValue.serverTimestamp(),
    };

    if (isModifing) {
      await FirebaseFirestore.instance
          .collection('news')
          .doc(news.id)
          .update(newsData)
          .catchError((e) {
        print('error on submitting the news $e');
        isLoading.value = false;
      });

      if (isPicChanged) {
        UploadedImage uploadedImage = await ImageController.uploadImage(
          imageFile: pickedImage.value,
          category: 'news',
          docID: news.id,
        );

        await FirebaseFirestore.instance
            .collection('news')
            .doc(news.id)
            .update({
          'imageURL': uploadedImage.imageURL,
          'imagePath': uploadedImage.imagePath,
        });
      }

      isLoading.value = false;
      Fluttertoast.showToast(msg: 'تم تعديل الفرصة بنجاح');
      Get.offAll(
        () => NavigatorPage(tabIndex: 2),
        duration: const Duration(microseconds: 1),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('news')
          .add(newsData)
          .then((value) async {
        UploadedImage uploadedImage = await ImageController.uploadImage(
          imageFile: pickedImage.value,
          category: 'news',
          docID: value.id,
        );

        await FirebaseFirestore.instance
            .collection('news')
            .doc(value.id)
            .update({
          'imageURL': uploadedImage.imageURL,
          'imagePath': uploadedImage.imagePath,
        });
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

  Future<void> deleteNews(News news) async {
    isLoading.value = true;
    await FirebaseFirestore.instance.collection('news').doc(news.id).delete();

    await FirebaseStorage.instance
        .ref()
        .child(news.imagePath)
        .delete()
        .catchError((e) {
      print('news can not be deleted $e');

      Get.offAll(
        () => NavigatorPage(tabIndex: 2),
        duration: const Duration(microseconds: 1),
      );
      isLoading.value = false;
    });
    Fluttertoast.showToast(msg: 'تم حذف الخبر');
    Get.offAll(
      () => NavigatorPage(tabIndex: 2),
      duration: const Duration(microseconds: 1),
    );

    isLoading.value = false;
  }
}
