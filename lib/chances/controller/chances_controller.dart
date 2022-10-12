import 'dart:io';

import 'package:app/widgets/navigator_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

enum Gender { males, females, both }

class ChancesController extends GetxController {
  final genderType = Gender.males.obs;
  final isTeamWork = false.obs;
  final isOnline = false.obs;
  final isUrgent = false.obs;
  final isSupportDisabled = false.obs;
  final isNeedInterview = false.obs;
  final pickedImage = File('').obs;
  final isLoading = false.obs;
  final ImagePicker picker = ImagePicker();

  Future<void> addChance({
    required String title,
    required String startDate,
    required String endDate,
    required String city,
    required String organization,
    required String sitsNo,
    required String category,
    required String requiredDegree,
    required Gender genderEnum,
    required bool isTeamWork,
    required bool isUrgent,
    required bool isOnline,
    required bool isSupportDisabled,
    required bool isNeedInterview,
    required String chanceURL,
  }) async {
    isLoading.value = true;
    String imageURL = await uploadImage(imageFile: pickedImage.value);

    await FirebaseFirestore.instance.collection('chances').doc().set({
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'city': city,
      'organization': organization,
      'sitsNo': sitsNo,
      'category': category,
      'degree': requiredDegree,
      'gender': getGenderType(genderEnum),
      'isTeamWork': isTeamWork,
      'isUrgent': isUrgent,
      'isOnline': isOnline,
      'isSupportDisabled': isSupportDisabled,
      'isNeedInterview': isNeedInterview,
      'imageURL': imageURL,
      'chanceURL': chanceURL,
      'timestamp': Timestamp.now(),
    }).then((value) {
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'تم إضافة الفرصة بنجاح');
      Get.offAll(
        () => NavigatorPage(tabIndex: 3),
        duration: const Duration(microseconds: 1),
      );
    }).catchError((e) {
      isLoading.value = false;
      print('error on adding chance $e');
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
    final ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('chances')
        .child(
            '${Timestamp.now().millisecondsSinceEpoch.toString()}$imageExtenstion');
    await ref.putFile(imageFile);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }
}

String getGenderType(Gender genderType) {
  switch (genderType) {
    case Gender.males:
      return 'males';
    case Gender.females:
      return 'females';
    case Gender.both:
      return 'both';
    default:
      return 'males';
  }
}
