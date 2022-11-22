import 'dart:io';

import 'package:app/general/model/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../general/controller/image_controller.dart';
import '../../widgets/navigator_page.dart';
import '../model/team.dart';

class TeamController extends GetxController {
  final isLoading = false.obs;
  final pickedImage = File('').obs;
  final List photoAlbum = [].obs;
  final ImagePicker picker = ImagePicker();

  Future<void> addModifyTeam({
    required Team team,
    bool isModifing = false,
    bool isPicChanged = false,
  }) async {
    isLoading.value = true;

    Map<String, dynamic> teamData = {
      'name': team.name,
      'brief': team.brief,
      'goals': team.goals,
      'category': team.category,
      'futurePlans': team.futurePlans,
      'teamLeaderEmail': team.teamLeaderEmail,
      'teamLeaderName': team.teamLeaderName,
      'deputyName': team.deputyName,
      'econmicName': team.econmicName,
      'mediaName': team.mediaName,
      'timestamp': isModifing ? team.timestamp : FieldValue.serverTimestamp(),
    };

    if (isModifing) {
      await FirebaseFirestore.instance
          .collection('teams')
          .doc(team.id)
          .update(teamData)
          .catchError((e) {
        print('error on submitting the news $e');
        isLoading.value = false;
      });

      if (isPicChanged) {
        UploadedImage uploadedImage = await ImageController.uploadImage(
          imageFile: pickedImage.value,
          category: 'teams',
          docID: team.id,
        );

        await FirebaseFirestore.instance
            .collection('team')
            .doc(team.id)
            .update({
          'imageURL': uploadedImage.imageURL,
          'imagePath': uploadedImage.imagePath,
        });
      }

      isLoading.value = false;
      Fluttertoast.showToast(msg: 'تم تعديل الفريق بنجاح');
      Get.offAll(
        () => NavigatorPage(),
        duration: const Duration(microseconds: 1),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('teams')
          .add(teamData)
          .then((doc) async {
        UploadedImage uploadedImage = await ImageController.uploadImage(
          imageFile: pickedImage.value,
          category: 'teams',
          docID: doc.id,
        );
        await FirebaseFirestore.instance
            .collection('teams')
            .doc(doc.id)
            .update({
          'imageURL': uploadedImage.imageURL,
          'imagePath': uploadedImage.imagePath,
        });

        isLoading.value = false;
        Fluttertoast.showToast(msg: 'تم إضافة الفريق بنجاح');
        Get.offAll(
          () => NavigatorPage(),
          duration: const Duration(microseconds: 1),
        );
      }).catchError((e) {
        print('error on submitting the news $e');
        isLoading.value = false;
      });
    }
  }

  Future<void> deleteTeam(Team team) async {
    isLoading.value = true;
    await FirebaseFirestore.instance.collection('news').doc(team.id).delete();

    await FirebaseStorage.instance
        .ref()
        .child(team.imagePath)
        .delete()
        .catchError((e) {
      print('error main image is not deleted $e');
      Get.offAll(
        () => NavigatorPage(),
        duration: const Duration(microseconds: 1),
      );
      isLoading.value = false;
    });

    Fluttertoast.showToast(msg: 'تم حذف الفريق');
    Get.offAll(
      () => NavigatorPage(),
      duration: const Duration(microseconds: 1),
    );

    isLoading.value = false;
  }
}
