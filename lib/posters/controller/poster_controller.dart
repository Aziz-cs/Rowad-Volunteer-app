import 'dart:io';

import 'package:app/general/model/image.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/navigator_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> addPoster({
    required String title,
    required String posterURL,
  }) async {
    isLoading.value = true;

    FirebaseFirestore.instance.collection('posters').add({
      'title': title,
      'timestamp': Timestamp.now(),
      'bannerURL': 'https://nvg.gov.sa/',
    }).then((value) async {
      UploadedImage uploadedImage = await ImageController.uploadImage(
        imageFile: pickedImage.value,
        category: 'posters',
        docID: value.id,
      );
      FirebaseFirestore.instance.collection('posters').doc(value.id).update({
        'imageURL': uploadedImage.imageURL,
        'imagePath': uploadedImage.imagePath,
      });
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
