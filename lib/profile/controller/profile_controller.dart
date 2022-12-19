import 'dart:io';

import 'package:app/profile/model/volunteer.dart';
import 'package:app/profile/view/complete_profile.dart';
import 'package:app/profile/view/widgets/optional_profile_data.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/sharedprefs.dart';
import 'package:app/widgets/navigator_page.dart';
import 'package:app/widgets/simple_btn.dart';
import 'package:app/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var isUploadingAvatar = false.obs;
  Future<void> pickImage() async {
    File pickedImage;
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile;
    String avatarURL = '';
    final isUploading = false.obs;
    try {
      imageFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 30,
      );
      isUploading.value = true;
      pickedImage = File(imageFile!.path);
    } catch (e) {
      print('error in image picking $e');
      return;
    }
    final ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
    await ref.putFile(pickedImage);
    avatarURL = await ref.getDownloadURL();
    print('avatar URL $avatarURL');
    // imageURL. = sharedPrefs.imageURL;
    isUploading.value = false;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {
        'avatarURL': avatarURL,
      },
    );
  }
}

void showEditOneParamaterDialog({
  required String dialogTitle,
  required String documentFieldKey,
  required String currentValue,
  bool isLTR = false,
  TextInputType textInputType = TextInputType.none,
}) {
  var formKey = GlobalKey<FormState>();
  var controller = TextEditingController();
  controller.text = currentValue;
  Get.defaultDialog(
    title: dialogTitle,
    content: Form(
      key: formKey,
      child: MyTextField(
        isLTRdirection: isLTR,
        inputType: textInputType,
        controller: controller,
        validator: (input) {
          if (input!.isEmpty) {
            return kErrEmpty;
          }
        },
      ),
    ),
    actions: [
      SimpleButton(
        label: 'تأكيد',
        onPress: () async {
          if (!formKey.currentState!.validate()) {
            return;
          }
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
                documentFieldKey: controller.text.trim(),
              })
              .then((value) => Fluttertoast.showToast(msg: 'تم التعديل بنجاح'))
              .catchError((e) {
                print('error editing  $e');
              });

          Get.back();
        },
      ),
      SimpleButton(
        label: 'إلغاء',
        onPress: () => Get.back(),
      ),
    ],
  );
}
