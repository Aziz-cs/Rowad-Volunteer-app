import 'package:app/notifications/controller/notification_controller.dart';
import 'package:app/profile/controller/profile_controller.dart';
import 'package:app/profile/model/volunteer.dart';
import 'package:app/profile/view/widgets/optional_profile_data.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/sharedprefs.dart';
import 'package:app/widgets/navigator_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CompleteProfileController extends GetxController {
  // Mandatory paramaters
  final mandatoryFormKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var phoneNoController = TextEditingController();

  var areaController = TextEditingController();
  var cityController = TextEditingController();
  var specializeController = TextEditingController();

  var userBirthday = ''.obs;
  final educationDegree = 'أخرى'.obs;
  final genderType = kChoose.obs;
  final volunteerLevel = kChoose.obs;

  // Optional parameters:
  var isAgreeTerms = false.obs;

  final optionalFromKey = GlobalKey<FormState>();

  var nationalIDController = TextEditingController();
  var nationalityController = TextEditingController();
  var socialStateController = TextEditingController();
  var jobController = TextEditingController();

  var workType = kChoose.obs;

  var language = 'العربية'.obs;
  var langLevel = kChoose.obs;

  final volunteerType = kChoose.obs;
  final userLanguageMap = {}.obs;

  var interest = kInterestsDefault.obs;
  final interestMap = {}.obs;

  var skill = kSkillDefault.obs;
  final usersSkillsList = [].obs;
  final usersInterestsList = [].obs;

  final isLoadingSavingProfileData = false.obs;

  bool isMandatoryFieldsNotValid() {
    if (userBirthday.isEmpty) {
      Fluttertoast.showToast(msg: 'برجاء ادخال تاريخ الميلاد');
      return true;
    }
    if (educationDegree.value == 'أخرى') {
      Fluttertoast.showToast(msg: 'برجاء اختيار المؤهل الدراسي');
      return true;
    }
    if (genderType.value == kChoose) {
      Fluttertoast.showToast(msg: 'برجاء اختيار الجنس');
      return true;
    }
    if (volunteerLevel.value == kChoose) {
      Fluttertoast.showToast(msg: 'برجاء اختيار مستوى التطوع');
      return true;
    }
    return false;
  }

  Future<void> submitProfileData() async {
    isLoadingSavingProfileData.value = true;

    Volunteer volunteerProfile = Volunteer(
      id: FirebaseAuth.instance.currentUser!.uid,
      email: FirebaseAuth.instance.currentUser?.email ?? '',
      name: nameController.text,
      phoneNo: phoneNoController.text,
      birthday: userBirthday.value,
      isMale: genderType.value == 'أنثى' ? false : true,
      area: areaController.text,
      city: cityController.text,
      educationDegree: educationDegree.value,
      specialization: specializeController.text,
      volunteerLevel: volunteerLevel.value,
      userRole: kVolunteer,
      avatarURL: '',
      nationalID: nationalIDController.text,
      nationality: nationalityController.text,
      socialState: socialStateController.text,
      workType: workType.value,
      job: jobController.text,
      languages: userLanguageMap,
      skillsList: List.from(usersSkillsList),
      interestsList: List.from(usersInterestsList),
      timestamp: Timestamp.now(),
    );

    Map<String, dynamic> profileData = {
      'id': FirebaseAuth.instance.currentUser!.uid,
      'email': FirebaseAuth.instance.currentUser?.email,
      'name': nameController.text.trim(),
      'phoneNo': phoneNoController.text.trim(),
      'birthday': userBirthday.value.trim(),
      'isMale': genderType.value == 'أنثى' ? false : true,
      'area': areaController.text.trim(),
      'city': cityController.text.trim(),
      'educationDegree': educationDegree.value.trim(),
      'specialization': specializeController.text.trim(),
      'volunteerLevel': volunteerLevel.value.trim(),
      'nationalID': nationalIDController.text.trim(),
      'nationality': nationalityController.text.trim(),
      'socialState': socialStateController.text.trim(),
      'workType': workType.value.trim(),
      'job': jobController.text.trim(),
      'languages': userLanguageMap,
      'skillsList': usersSkillsList,
      'interestsList': usersInterestsList,
      'userRole': kVolunteer,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(profileData)
        .then((value) {
      subscribeUserToTopic(
          userID: FirebaseAuth.instance.currentUser!.uid,
          topicName: FirebaseAuth.instance.currentUser!.uid);

      subscribeUserToTopic(
        userID: FirebaseAuth.instance.currentUser!.uid,
        topicName: kGlobalNotifications,
      );

      sharedPrefs.isCompletedProfile = true;
      isLoadingSavingProfileData.value = false;
      Fluttertoast.showToast(msg: 'تم حفظ البيانات بنجاح');
      Get.offAll(() => NavigatorPage());
    }).catchError((e) {
      isLoadingSavingProfileData.value = false;
    });
  }
}
