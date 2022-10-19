import 'dart:io';

import 'package:app/widgets/navigator_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import '../../controller/image_controller.dart';

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
    required String shortDesc,
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
    String imageURL = await ImageController.uploadImage(
      imageFile: pickedImage.value,
      category: 'chances',
    );

    await FirebaseFirestore.instance.collection('chances').add({
      'title': title,
      'shortDesc': title,
      'startDate': startDate,
      'endDate': endDate,
      'city': city,
      'organization': organization,
      'sitsNo': sitsNo,
      'category': category,
      'requiredDegree': requiredDegree,
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
        () => NavigatorPage(tabIndex: 1),
        duration: const Duration(microseconds: 1),
      );
    }).catchError((e) {
      isLoading.value = false;
      print('error on adding chance $e');
    });
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
