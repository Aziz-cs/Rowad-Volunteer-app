import 'dart:io';

import 'package:app/general/model/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../general/controller/image_controller.dart';
import '../../widgets/navigator_page.dart';
import '../model/course.dart';

class CoursesController extends GetxController {
  final isLoading = false.obs;
  final pickedImage = File('').obs;
  final ImagePicker picker = ImagePicker();

  Future<void> addModifyCourses({
    required Course course,
    bool isModifing = false,
    bool isPicChanged = false,
  }) async {
    isLoading.value = true;
    Map<String, dynamic> courseData = {
      'name': course.name,
      'intro': course.intro,
      'details': course.details,
      'owner': course.owner,
      'instructorName': course.instructorName,
      'startDate': course.startDate,
      'duration': course.duration,
      'registerationURL': course.registerationURL,
      'isRegisterationOpen': course.isRegisterationOpen,
      'timestamp': isModifing ? course.timestamp : FieldValue.serverTimestamp(),
    };

    if (isModifing) {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(course.id)
          .update(courseData)
          .catchError((e) {
        print('error on submitting the course $e');
        isLoading.value = false;
      });

      if (isPicChanged) {
        UploadedImage uploadedImage = await ImageController.uploadImage(
          imageFile: pickedImage.value,
          category: 'courses',
          docID: course.id,
        );

        await FirebaseFirestore.instance
            .collection('courses')
            .doc(course.id)
            .update({
          'imageURL': uploadedImage.imageURL,
          'imagePath': uploadedImage.imagePath,
        });
      }

      isLoading.value = false;
      Fluttertoast.showToast(msg: 'تم تعديل الدورة بنجاح');
      Get.offAll(
        () => NavigatorPage(tabIndex: 2),
        duration: const Duration(microseconds: 1),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('courses')
          .add(courseData)
          .then((doc) async {
        UploadedImage uploadedImage = await ImageController.uploadImage(
          imageFile: pickedImage.value,
          category: 'courses',
          docID: doc.id,
        );
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(doc.id)
            .update({
          'imageURL': uploadedImage.imageURL,
          'imagePath': uploadedImage.imagePath,
        });

        isLoading.value = false;
        Fluttertoast.showToast(msg: 'تم إضافة الدورة بنجاح');
        Get.offAll(
          () => NavigatorPage(tabIndex: 2),
          duration: const Duration(microseconds: 1),
        );
      }).catchError((e) {
        print('error on submitting the course $e');
        isLoading.value = false;
      });
    }
  }

  Future<void> deleteCourse(Course course) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(course.id)
        .delete();

    await FirebaseStorage.instance
        .ref()
        .child(course.imagePath)
        .delete()
        .catchError((e) {
      print('error main image is not deleted $e');
      Get.offAll(
        () => NavigatorPage(tabIndex: 2),
        duration: const Duration(microseconds: 1),
      );
      isLoading.value = false;
    });

    Fluttertoast.showToast(msg: 'تم حذف الدورة');
    Get.offAll(
      () => NavigatorPage(tabIndex: 2),
      duration: const Duration(microseconds: 1),
    );

    isLoading.value = false;
  }
}
