import 'dart:io';

import 'package:app/general/model/image.dart';
import 'package:app/widgets/navigator_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../general/controller/image_controller.dart';
import '../model/chance.dart';

enum Gender { males, females, both }

const String kMales = 'رجال';
const String kFemales = 'نساء';
const String kGenderBoth = 'الجنسين';
const String kDBChances = 'chances';

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

  Future<void> addModifyChance({
    required Chance chance,
    bool isModifing = false,
    bool isPicChanged = false,
  }) async {
    isLoading.value = true;

    Map<String, dynamic> chanceMapData = {
      'title': chance.title,
      'shortDesc': chance.shortDesc,
      'startDate': chance.startDate,
      'endDate': chance.endDate,
      'area': chance.area,
      'city': chance.city,
      'organization': chance.organization,
      'sitsNo': chance.sitsNo,
      'category': chance.category,
      'requiredDegree': chance.requiredDegree,
      'gender': chance.gender,
      'isTeamWork': chance.isTeamWork,
      'isUrgent': chance.isUrgent,
      'isOnline': chance.isOnline,
      'isSupportDisabled': chance.isSupportDisabled,
      'isNeedInterview': chance.isNeedInterview,
      'chanceURL': chance.chanceURL,
      'imageURL': chance.imageURL,
      'imagePath': chance.imagePath,
      'timestamp': isModifing ? chance.timestamp : FieldValue.serverTimestamp(),
    };
    if (isModifing) {
      // modifiying old chance
      await FirebaseFirestore.instance
          .collection(kDBChances)
          .doc(chance.id)
          .update(chanceMapData)
          .catchError((e) {
        isLoading.value = false;
        print('error on editing chance $e');
      });

      if (isPicChanged) {
        UploadedImage uploadedImage = await ImageController.uploadImage(
          imageFile: pickedImage.value,
          category: kDBChances,
          docID: chance.id,
        );
        await FirebaseFirestore.instance
            .collection(kDBChances)
            .doc(chance.id)
            .update({
          'imageURL': uploadedImage.imageURL,
          'imagePath': uploadedImage.imagePath,
        });
      }
      isLoading.value = false;
      Fluttertoast.showToast(msg: 'تم تعديل الفرصة بنجاح');
      Get.offAll(
        () => NavigatorPage(tabIndex: 1),
        duration: const Duration(microseconds: 1),
      );
    } else {
      // adding new chance
      await FirebaseFirestore.instance
          .collection(kDBChances)
          .add(chanceMapData)
          .then((value) async {
        UploadedImage uploadedImage = await ImageController.uploadImage(
          imageFile: pickedImage.value,
          category: kDBChances,
          docID: value.id,
        );
        await FirebaseFirestore.instance
            .collection(kDBChances)
            .doc(value.id)
            .update({
          'imageURL': uploadedImage.imageURL,
          'imagePath': uploadedImage.imagePath,
        });

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
        return kMales;
      case Gender.females:
        return kFemales;
      case Gender.both:
        return kGenderBoth;
      default:
        return kGenderBoth;
    }
  }

  Future<void> deleteChance(Chance chance) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection('chances')
        .doc(chance.id)
        .delete();

    await FirebaseStorage.instance
        .ref()
        .child(chance.imagePath)
        .delete()
        .catchError((e) {
      print('image can not be deleted $e');

      Get.offAll(
        () => NavigatorPage(tabIndex: 1),
        duration: const Duration(microseconds: 1),
      );
      isLoading.value = false;
    });
    Fluttertoast.showToast(msg: 'تم حذف الفرصة');
    Get.offAll(
      () => NavigatorPage(tabIndex: 1),
      duration: const Duration(microseconds: 1),
    );

    isLoading.value = false;
  }

  // Future<void> modifyChance({required Chance chance}) async {}
}
