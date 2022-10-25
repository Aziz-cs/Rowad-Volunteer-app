import 'dart:io';

import 'package:app/general/model/image.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/navigator_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../general/controller/image_controller.dart';
import '../model/poster.dart';

class PosterController extends GetxController {
  List<Poster> posters = [];
  final isLoading = false.obs;
  final pickedImage = File('').obs;
  final ImagePicker picker = ImagePicker();

  Future<void> addModifyPoster({
    required Poster poster,
    bool isModifying = false,
    bool isPicChanged = false,
  }) async {
    isLoading.value = true;
    print('isPicChanged $isPicChanged');
    if (isModifying) {
      await FirebaseFirestore.instance
          .collection('posters')
          .doc(poster.id)
          .update({
        'title': poster.title,
        'posterURL': poster.posterURL,
      });

      if (isPicChanged) {
        UploadedImage uploadedImage = await ImageController.uploadImage(
          imageFile: pickedImage.value,
          category: 'posters',
          docID: poster.id,
        ).catchError((e) {
          isLoading.value = false;
          Fluttertoast.showToast(msg: 'خطأ في رفع الصورة');
          print('error on uploading image $e');
        });

        await FirebaseFirestore.instance
            .collection('posters')
            .doc(poster.id)
            .update({
          'imageURL': uploadedImage.imageURL,
          'imagePath': uploadedImage.imagePath,
        });
      }

      isLoading.value = false;
      Fluttertoast.showToast(msg: 'تم تعديل الإعلان بنجاح');
      Get.offAll(() => NavigatorPage(tabIndex: 0));
    } else {
      FirebaseFirestore.instance.collection('posters').add({
        'title': poster.title,
        'timestamp': FieldValue.serverTimestamp(),
        'posterURL': poster.posterURL,
      }).then((value) async {
        UploadedImage uploadedImage = await ImageController.uploadImage(
          imageFile: pickedImage.value,
          category: 'posters',
          docID: value.id,
        );
        await FirebaseFirestore.instance
            .collection('posters')
            .doc(value.id)
            .update({
          'imageURL': uploadedImage.imageURL,
          'imagePath': uploadedImage.imagePath,
        });
        isLoading.value = false;
        Fluttertoast.showToast(msg: 'تم نشر الإعلان بنجاح');
        Get.offAll(() => NavigatorPage(tabIndex: 0));
      }).catchError((e) {
        print('error on publishing poster $e');
        isLoading.value = false;
        Fluttertoast.showToast(msg: kErrSomethingWrong);
      });
    }
  }

  Future<void> deletePoster(Poster poster) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection('posters')
        .doc(poster.id)
        .delete();

    await FirebaseStorage.instance
        .ref()
        .child(poster.imagePath)
        .delete()
        .catchError((e) {
      print("error on deleting poster's image $e");
    });
    isLoading.value = true;
    Fluttertoast.showToast(msg: 'تم حذف الإعلان بنجاح');
    Get.offAll(() => NavigatorPage(tabIndex: 0));
  }
}
