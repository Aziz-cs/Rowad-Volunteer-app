import 'dart:io';

import 'package:app/controller/image_controller.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/navigator_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/poster.dart';

class PosterController extends GetxController {
  List<Poster> posters = [];
  final isLoading = false.obs;
  final pickedImage = File('').obs;
  final ImagePicker picker = ImagePicker();

  Future<void> addPoster({
    required String title,
    required String posterURL,
  }) async {
    isLoading.value = true;
    String imageURL = await ImageController.uploadImage(
        imageFile: pickedImage.value, category: 'posters');
    FirebaseFirestore.instance.collection('posters').add({
      'title': title,
      'imageURL': imageURL,
      'timestamp': Timestamp.now(),
      'bannerURL': 'https://nvg.gov.sa/',
    }).then((value) {
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'تم نشر الإعلان بنجاح');
      Get.offAll(() => NavigatorPage(tabIndex: 0));
    }).catchError((e) {
      print('error on publishing poster $e');
      isLoading.value = false;
      Fluttertoast.showToast(msg: kErrEmpty);
    });
  }
}
