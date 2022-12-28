import 'dart:io';

import 'package:app/profile/model/volunteer.dart';
import 'package:app/profile/view/widgets/optional_profile_data.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/sharedprefs.dart';
import 'package:app/widgets/dropdown_menu.dart';
import 'package:app/widgets/simple_btn.dart';
import 'package:app/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

const String kVolunteer = 'volunteer';
const String kEditor = 'editor';
const String kTeamLeader = 'teamLeader';
const String kAdmin = 'admin';

const String kVolunteerAR = 'متطوع';
const String kEditorAR = 'محرر';
const String kTeamLeaderAR = 'قائد فريق';
const String kAdminAR = 'المدير';

List<String> subscribedTopicsList = [
  'global',
];

late Volunteer currentVolunteer;

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

void showDropDownMenuEditDialog({
  required String dialogTitle,
  required String documentFieldKey,
  required String currentValue,
  required List<String> choicesList,
  bool isLTR = false,
  bool isGenderDialog = false,
  TextInputType textInputType = TextInputType.none,
}) {
  var newValue = currentValue.obs;
  Get.defaultDialog(
    title: dialogTitle,
    content: Directionality(
      textDirection: isLTR ? TextDirection.ltr : TextDirection.rtl,
      child: Obx(
        () => DropDownMenu(
          fontSize: 17,
          value: newValue.value,
          items: choicesList,
          removeHeightPadding: true,
          onChanged: (selectedValue) {
            newValue.value = selectedValue ?? newValue.value;
          },
        ),
      ),
    ),
    actions: [
      SimpleButton(
        label: 'تأكيد',
        onPress: () async {
          if (newValue.value == currentValue) {
            Get.back();
            return;
          }
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
                documentFieldKey: isGenderDialog
                    ? newValue.value == 'ذكر'
                        ? true
                        : false
                    : newValue.value,
              })
              .then((value) => print('changed'))
              .catchError((e) {
                print('error editing  $e');
              });
          Fluttertoast.showToast(msg: 'تم التعديل بنجاح');
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

String getUserRoleInAROf(String userRoleEN) {
  switch (userRoleEN) {
    case kVolunteer:
      return kVolunteerAR;
    case kEditor:
      return kEditorAR;
    case kTeamLeader:
      return kTeamLeaderAR;
    case kAdmin:
      return kAdminAR;
    default:
      return kTeamLeaderAR;
  }
}

String getUserRoleInENOf(String userRoleAR) {
  switch (userRoleAR) {
    case kVolunteerAR:
      return kVolunteer;
    case kEditorAR:
      return kEditor;
    case kTeamLeaderAR:
      return kTeamLeader;
    case kAdminAR:
      return kAdmin;
    default:
      return kTeamLeader;
  }
}

void subscribeToUserTopics() {
  FirebaseMessaging.instance
      .subscribeToTopic(FirebaseAuth.instance.currentUser!.uid);
  FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('subscribedTopics')
      .get()
      .then((subscribedTopicsDocs) {
    subscribedTopicsList.clear();
    subscribedTopicsList.add('global');
    subscribedTopicsDocs.docs.forEach((element) {
      subscribedTopicsList.add(element['topicName']);
      FirebaseMessaging.instance.subscribeToTopic(element['topicName']);
    });

    print(subscribedTopicsList);
  });
}

void clearUserData() {
  subscribedTopicsList.forEach((topicName) {
    FirebaseMessaging.instance.unsubscribeFromTopic(topicName);
  });
  // currentVolunteer.skillsList.forEach((skillName) {
  //   FirebaseMessaging.instance.unsubscribeFromTopic(skillName);
  // });
  // currentVolunteer.interestsList.forEach((interest) {
  //   FirebaseMessaging.instance.unsubscribeFromTopic(interest);
  // });
  SharedPrefs.clearData();
}

Future<void> setUserInitialData() async {
  print('setting initial data');
  FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((value) {
    currentVolunteer =
        Volunteer.fromDB(value.data() as Map<String, dynamic>, value.id);
    sharedPrefs.userRole = currentVolunteer.userRole;
    sharedPrefs.userName = currentVolunteer.name;

    // currentVolunteer.interestsList.forEach((skillName) {
    //   print('skill Name: $skillName');
    //   FirebaseMessaging.instance.subscribeToTopic(skillName);
    // });
    // currentVolunteer.interestsList.forEach((interestName) {
    //   print('interestName : $interestName');
    //   FirebaseMessaging.instance.subscribeToTopic(interestName);
    // });
  });
}

void showEditSkillsDialog({
  required String dialogTitle,
  required String documentFieldKey,
  required List currentList,
  bool isLTR = false,
  bool isGenderDialog = false,
  TextInputType textInputType = TextInputType.none,
}) {
  var usersSkillsList = currentList.obs;
  var skillsList = [
    kSkillDefault,
    'مهارات فنية متخصصة',
    'مهارات إدارية',
    'مهارات التعامل مع الفئات الخاصة',
    'مهارات إدارة الوقت',
    'مهارات إعلامية',
    'إدارة وقيادة',
    'مهارات الاتصال',
    'مهارات التنظيم وإدارة فرق العمل والحشود',
    'مهارات التسويق',
    'مهارات لغات وترجمة',
    'مهارات تحليل البيانات',
    'مهارات الالقاء والخطابة',
    'مهارات التدريب',
    'التخطيط',
    'مهارات تقنية',
    'مهارة إدارة المخاطر',
    'أخرى',
  ].obs;
  var skill = kSkillDefault.obs;

  usersSkillsList.forEach((element) {
    skillsList.remove(element);
  });
  Get.defaultDialog(
    title: dialogTitle,
    content: Directionality(
        textDirection: isLTR ? TextDirection.ltr : TextDirection.rtl,
        child: Column(
          children: [
            Obx(
              () => DropDownMenu(
                fontSize: 17,
                value: skill.value,
                items: skillsList,
                removeHeightPadding: true,
                onChanged: (selectedValue) {
                  skill.value = selectedValue ?? skill.value;
                  if (skill.value == kSkillDefault) {
                    return;
                  }

                  usersSkillsList.add(skill.value);
                  skillsList.remove(skill.value);
                  skill.value = kSkillDefault;
                  print(usersSkillsList);
                },
              ),
            ),
            Obx(() => Wrap(
                  children: List.generate(
                      usersSkillsList.length,
                      (index) => InkWell(
                            onTap: () {
                              skillsList.add(usersSkillsList[index]);
                              usersSkillsList.remove(usersSkillsList[index]);
                              skillsList.refresh();
                              // usersSkillsList.refresh();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              margin: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: const Color(0xFF87a594),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    CupertinoIcons.xmark,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    usersSkillsList[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                )),
          ],
        )),
    actions: [
      SimpleButton(
        label: 'تأكيد',
        onPress: () async {
          // if (newValue.value == currentValue) {
          //   Get.back();
          //   return;
          // }
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'skillsList': usersSkillsList})
              .then((value) => print('changed'))
              .catchError((e) {
                print('error editing  $e');
              });
          Fluttertoast.showToast(msg: 'تم التعديل بنجاح');
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

void showEditInterestsDialog({
  required String dialogTitle,
  required String documentFieldKey,
  required List currentList,
  bool isLTR = false,
  bool isGenderDialog = false,
  TextInputType textInputType = TextInputType.none,
}) {
  var usersInterestsList = currentList.obs;
  var interest = kInterestsDefault.obs;

  var interestsList = [
    kInterestsDefault,
    'فني',
    'مالي',
    'قانوني',
    'بيئي',
    'تدريبي',
    'ترفيهي',
    'صحي',
    'تقني',
    'تسويقي',
    'تربوي',
    'الأمن والسلامة',
    'اجتماعي',
    'نفسي',
    'ثقافي',
    'الإغاثة',
    'خدمي',
    'رياضي',
    'عام',
    'هندسة',
    'إداري',
    'تعليمي',
    'ديني',
    'الاسكاني',
    'أخرى',
    'إعلامي',
    'السياحة',
    'خدمة ضيوف الرحمن',
    'تأهيلي',
    'تنظيمي',
  ].obs;

  usersInterestsList.forEach((element) {
    interestsList.remove(element);
  });

  Get.defaultDialog(
    title: dialogTitle,
    content: Directionality(
        textDirection: isLTR ? TextDirection.ltr : TextDirection.rtl,
        child: Column(
          children: [
            Obx(
              () => DropDownMenu(
                fontSize: 17,
                value: interest.value,
                items: interestsList,
                removeHeightPadding: true,
                onChanged: (selectedValue) {
                  interest.value = selectedValue ?? interest.value;
                  if (interest.value == kInterestsDefault) {
                    return;
                  }

                  usersInterestsList.add(interest.value);
                  interestsList.remove(interest.value);
                  interest.value = kInterestsDefault;
                  print(usersInterestsList);
                },
              ),
            ),
            Obx(() => Wrap(
                  children: List.generate(
                      usersInterestsList.length,
                      (index) => InkWell(
                            onTap: () {
                              interestsList.add(usersInterestsList[index]);
                              usersInterestsList
                                  .remove(usersInterestsList[index]);
                              interestsList.refresh();
                              // usersSkillsList.refresh();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              margin: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: const Color(0xFF87a594),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    CupertinoIcons.xmark,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    usersInterestsList[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                )),
          ],
        )),
    actions: [
      SimpleButton(
        label: 'تأكيد',
        onPress: () async {
          // if (newValue.value == currentValue) {
          //   Get.back();
          //   return;
          // }
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'interestsList': usersInterestsList})
              .then((value) => print('changed'))
              .catchError((e) {
                print('error editing  $e');
              });
          Fluttertoast.showToast(msg: 'تم التعديل بنجاح');
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
