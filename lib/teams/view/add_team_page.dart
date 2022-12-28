import 'dart:io';

import 'package:app/profile/controller/profile_controller.dart';
import 'package:app/teams/controller/team_controller.dart';
import 'package:app/teams/model/team.dart';
import 'package:app/utils/sharedprefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../general/controller/image_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/circular_loading.dart';
import '../../widgets/dropdown_menu.dart';
import '../../widgets/simple_btn.dart';
import '../../widgets/textfield.dart';

class AddTeamPage extends StatelessWidget {
  AddTeamPage({Key? key}) : super(key: key);
  final teamController = Get.put(TeamController());

  final _addCategoryController = TextEditingController();
  final _isLoading = false.obs;

  final _formKey = GlobalKey<FormState>();

  final _teamNameController = TextEditingController();
  final _teamFuturePlansController = TextEditingController();
  final _teamGoalsController = TextEditingController();
  final _teamBriefController = TextEditingController();
  final _teamLeaderEmailController = TextEditingController();
  final _teamDeputyController = TextEditingController();
  final _teamMediaController = TextEditingController();
  final _teamEconomicController = TextEditingController();
  final teamCategory = '- اختر -'.obs;

  // late final XFile? pickedImage;
  @override
  Widget build(BuildContext context) {
    clearProperties();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenColor,
        title: const Text('إضافة فريق تطوعي'),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اسم الفريق',
                  style: kTitleTextStyle,
                ),
                MyTextField(
                  controller: _teamNameController,
                  validator: (input) {
                    if (input!.isEmpty) {
                      return kErrEmpty;
                    }
                  },
                ),
                Text(
                  'نبذة عن الفريق',
                  style: kTitleTextStyle,
                ),
                MyTextField(
                  controller: _teamBriefController,
                  maxLines: 4,
                  validator: (input) {
                    if (input!.isEmpty) {
                      return kErrEmpty;
                    }
                  },
                ),
                Text(
                  'الأهداف',
                  style: kTitleTextStyle,
                ),
                MyTextField(
                  inputAction: TextInputAction.newline,
                  inputType: TextInputType.multiline,
                  controller: _teamGoalsController,
                  maxLines: 4,
                  validator: (input) {
                    // if (input!.isEmpty) {
                    //   return kErrEmpty;
                    // }
                  },
                ),
                Text(
                  'الخطط المستقبلية',
                  style: kTitleTextStyle,
                ),
                MyTextField(
                  inputAction: TextInputAction.newline,
                  inputType: TextInputType.multiline,
                  controller: _teamFuturePlansController,
                  maxLines: 4,
                  validator: (input) {
                    // if (input!.isEmpty) {
                    //   return kErrEmpty;
                    // }
                  },
                ),
                Text(
                  'التصنيف',
                  style: kTitleTextStyle,
                ),
                Row(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('general_categories')
                              .orderBy('name')
                              .snapshots(),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              List<String> categoriesList = [];
                              var result = snapshot.data!.docs;
                              result.forEach((element) {
                                Map category = element.data() as Map;
                                categoriesList.add(category['name']);
                              });
                              return Obx(() => DropDownMenu(
                                    value: teamCategory.value,
                                    items: categoriesList.toList(),
                                    removeHeightPadding: true,
                                    onChanged: (selectedValue) {
                                      teamCategory.value =
                                          selectedValue ?? teamCategory.value;
                                    },
                                  ));
                            }
                            return Center(child: CircularLoading());
                          })),
                    ),
                    // SimpleButton(
                    //   label: 'اضف تصنيفا',
                    //   onPress: () => showAddCategoryDialog(),
                    // ),
                  ],
                ),
                Text(
                  'صورة رمزية للفريق',
                  style: kTitleTextStyle,
                ),
                SimpleButton(
                    label: 'أختر الصورة',
                    onPress: () async {
                      teamController.pickedImage.value =
                          await ImageController.pickImage();
                    }),
                Obx(
                  () => teamController.pickedImage.value.path.isEmpty
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.file(
                              File(teamController.pickedImage.value.path),
                              width: 250.w,
                            ),
                          ],
                        ),
                ),
                SizedBox(height: 5.h),
                Obx(
                  () => teamController.isTeamLeaderEmailValid.isTrue
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: kGreenColor,
                              size: 24,
                            ),
                            Row(
                              children: [
                                Text(
                                  teamController.teamLeaderName,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Text(
                                  ' | ',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: kGreenColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  teamController.teamLeaderEmail,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: buildAddUserRoleToTeam(
                                inputType: TextInputType.emailAddress,
                                userRole: 'البريد الألكتروني لقائد الفريق',
                                isLTRdirection: true,
                                hintText: 'البريد المسجل به العضو',
                                controller: _teamLeaderEmailController,
                                isOptional: false,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25.h, right: 5.w),
                              child: Obx(
                                  () => teamController.isCheckingEmail.isTrue
                                      ? CircularLoading()
                                      : SimpleButton(
                                          label: 'تعيين',
                                          onPress: () async {
                                            await teamController
                                                .checkTeamLeaderEmailValid(
                                                    _teamLeaderEmailController
                                                        .text
                                                        .trim());
                                          },
                                        )),
                            ),
                          ],
                        ),
                ),
                buildAddUserRoleToTeam(
                  userRole: 'نائب الفريق',
                  controller: _teamDeputyController,
                ),
                buildAddUserRoleToTeam(
                  userRole: 'العضو الإعلامي',
                  controller: _teamMediaController,
                ),
                buildAddUserRoleToTeam(
                  userRole: 'العضو المالي',
                  controller: _teamEconomicController,
                ),
                SizedBox(height: 5.h),
                Obx(() => teamController.isLoading.isTrue
                    ? Center(child: CircularLoading())
                    : SimpleButton(
                        label: 'إضافة الفريق',
                        onPress: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          // if (teamController.pickedImage.value.path.isEmpty) {
                          //   Fluttertoast.showToast(
                          //       msg: 'برجاء رفع صورة للفريق');
                          //   return;
                          // }
                          if (teamController.isTeamLeaderEmailValid.isFalse) {
                            Fluttertoast.showToast(
                                msg: 'برجاء تعيين قائد للفريق');
                            return;
                          }

                          if (teamCategory.value == kChoose) {
                            Fluttertoast.showToast(msg: 'برجاء إختيار التصنيف');
                            return;
                          }

                          Team team = Team(
                            name: _teamNameController.text.trim(),
                            brief: _teamBriefController.text.trim(),
                            goals: _teamGoalsController.text.trim(),
                            futurePlans: _teamFuturePlansController.text.trim(),
                            category: teamCategory.value,
                            teamLeaderEmail:
                                teamController.teamLeaderEmail.toLowerCase(),
                            teamLeaderName: teamController.teamLeaderName,
                            teamLeaderID: teamController.teamLeaderID,
                            deputyName: _teamDeputyController.text.trim(),
                            mediaName: _teamMediaController.text.trim(),
                            econmicName: _teamEconomicController.text.trim(),
                            id: '',
                            imageURL:
                                teamController.pickedImage.value.path.isEmpty
                                    ? kDefaultImgURL
                                    : '',
                            imagePath: '',
                            timestamp: Timestamp.now(),
                          );

                          teamController.addModifyTeam(team: team);
                        },
                      )),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void clearProperties() {
    teamController.pickedImage.value = File('');
    teamController.isTeamLeaderEmailValid.value = false;
    teamController.teamLeaderEmail = '';
    teamController.teamLeaderName = '';
    _teamNameController.clear();
    _teamFuturePlansController.clear();
    _teamGoalsController.clear();
    _teamLeaderEmailController.clear();
    _teamDeputyController.clear();
    _teamMediaController.clear();
    _teamEconomicController.clear();
  }
}

Column buildAddUserRoleToTeam({
  required String userRole,
  String hintText = 'الأسم',
  bool isLTRdirection = false,
  bool isOptional = true,
  TextInputType inputType = TextInputType.name,
  required TextEditingController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        userRole,
        style: kTitleTextStyle,
      ),
      Row(
        children: [
          Expanded(
            flex: 3,
            child: MyTextField(
              inputType: inputType,
              isLTRdirection: isLTRdirection,
              controller: controller,
              hintText: hintText,
              validator: (input) {
                if (input!.isEmpty && !isOptional) {
                  return kErrEmpty;
                }
                if (isLTRdirection) {
                  if (!GetUtils.isEmail(input)) {
                    return kErrInvalidEmail;
                  }
                }
              },
            ),
          ),
          // SizedBox(width: 3.w),
          // Expanded(
          //   child: SimpleButton(label: 'تعيين', onPress: () {}),
          // ),
        ],
      ),
    ],
  );
}
