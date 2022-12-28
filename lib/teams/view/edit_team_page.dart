import 'dart:io';

import 'package:app/news/controller/news_controller.dart';
import 'package:app/news/model/news.dart';
import 'package:app/profile/controller/profile_controller.dart';
import 'package:app/teams/controller/team_controller.dart';
import 'package:app/teams/model/team.dart';
import 'package:app/teams/view/add_team_page.dart';
import 'package:app/teams/view/wysiwyg_editor_page.dart';
import 'package:app/utils/sharedprefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../general/controller/image_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/circular_loading.dart';
import '../../widgets/dropdown_menu.dart';
import '../../widgets/simple_btn.dart';
import '../../widgets/textfield.dart';

class EditTeamPage extends StatelessWidget {
  EditTeamPage({
    Key? key,
    required this.team,
  }) : super(key: key);

  final Team team;
  final teamController = Get.put(TeamController());

  final _addCategoryController = TextEditingController();
  final _isLoading = false.obs;

  final _formKey = GlobalKey<FormState>();

  final _teamNameController = TextEditingController();
  final _teamFuturePlansController = TextEditingController();
  final _teamGoalsController = TextEditingController();
  final _teamBriefController = TextEditingController();
  final _teamLeaderEmailController = TextEditingController();
  final _teamLeaderNameController = TextEditingController();
  final _teamDeputyController = TextEditingController();
  final _teamMediaController = TextEditingController();
  final _teamEconomicController = TextEditingController();
  final teamCategory = '- اختر -'.obs;

  String currentTeamLeaderEmail = '';

  // late final XFile? pickedImage;
  @override
  Widget build(BuildContext context) {
    setProperties();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kGreenColor,
          title: const Text('تعديل فريق تطوعي'),
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
                    validator: (input) {},
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
                    validator: (input) {},
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
                      SimpleButton(
                        label: 'اضف تصنيفا',
                        onPress: () => showAddCategoryDialog(),
                      ),
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
                  Obx(() => teamController.isTeamLeaderEmailValid.isTrue
                      ? const Center(child: Text('قائد الفريق'))
                      : const SizedBox()),
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
                                            label: 'تغيير',
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
                          label: 'تعديل الفريق',
                          onPress: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            if (teamCategory.value == kChoose) {
                              Fluttertoast.showToast(
                                  msg: 'برجاء إختيار التصنيف');
                              return;
                            }

                            Team modifiedTeam = Team(
                              name: _teamNameController.text.trim(),
                              brief: _teamBriefController.text.trim(),
                              goals: _teamGoalsController.text.trim(),
                              futurePlans:
                                  _teamFuturePlansController.text.trim(),
                              category: teamCategory.value,
                              teamLeaderEmail: teamController.teamLeaderEmail,
                              teamLeaderName: teamController.teamLeaderName,
                              teamLeaderID: teamController.teamLeaderID,
                              deputyName: _teamDeputyController.text.trim(),
                              mediaName: _teamMediaController.text.trim(),
                              econmicName: _teamEconomicController.text.trim(),
                              id: team.id,
                              imageURL: team.imageURL,
                              imagePath: team.imagePath,
                              timestamp: team.timestamp,
                            );

                            bool isTeamLeaderEmailChanged =
                                currentTeamLeaderEmail !=
                                    teamController.teamLeaderEmail;

                            if (isTeamLeaderEmailChanged) {
                              print('Email has been changed, removing..');
                              teamController.removeTeamLeader(
                                email: currentTeamLeaderEmail,
                                teamID: team.id,
                              );
                            }
                            teamController.addModifyTeam(
                              team: modifiedTeam,
                              isModifing: true,
                              isPicChanged: teamController
                                  .pickedImage.value.path.isNotEmpty,
                              isTeamLeaderChanged: isTeamLeaderEmailChanged,
                            );
                          },
                        )),
                  if (sharedPrefs.userRole == kAdmin)
                    Obx(() => teamController.isDeleteLoading.isTrue
                        ? Center(child: CircularLoading())
                        : SimpleButton(
                            backgroundColor: Colors.red.shade500,
                            label: 'حذف الفريق',
                            onPress: () {
                              teamController.deleteTeam(team);
                            },
                          )),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showAddCategoryDialog() {
    Get.defaultDialog(
      title: 'اضافة تصنيف',
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Expanded(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('general_categories')
                      .orderBy('name')
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var result = snapshot.data!.docs;
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              result.length,
                              (index) => result[index]['name'] == kChoose
                                  ? const SizedBox()
                                  : ListTile(
                                      title: Text(result[index]['name']),
                                      // trailing: IconButton(
                                      //   icon: const Icon(
                                      //     CupertinoIcons.xmark,
                                      //     size: 18,
                                      //     color: Colors.red,
                                      //   ),
                                      //   onPressed: () {
                                      //     FirebaseFirestore.instance
                                      //         .collection('general_categories')
                                      //         .doc(result[index].id)
                                      //         .delete();
                                      //     Fluttertoast.showToast(
                                      //         msg: 'تم حذف التصنيف');
                                      //   },
                                      // ),
                                    ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Center(child: CircularLoading());
                  })),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        hintText: 'التصنيف الجديد',
                        controller: _addCategoryController,
                        validator: (input) {}),
                  ),
                  Obx(() => _isLoading.isTrue
                      ? CircularLoading()
                      : IconButton(
                          icon: const Icon(
                            CupertinoIcons.add_circled_solid,
                            color: kGreenColor,
                            size: 30,
                          ),
                          onPressed: () async {
                            print('pressed');
                            if (_addCategoryController.text.trim().isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'برجاء كتابة التصنيف');
                              return;
                            }
                            _isLoading.value = true;
                            await FirebaseFirestore.instance
                                .collection('general_categories')
                                .add({
                              'name': _addCategoryController.text.trim(),
                            });
                            Fluttertoast.showToast(msg: 'تم إضافة التصنيف');
                            _isLoading.value = false;
                            _addCategoryController.clear();
                          },
                        ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void setProperties() {
    _teamNameController.text = team.name;
    _teamFuturePlansController.text = team.futurePlans;
    _teamGoalsController.text = team.goals;
    _teamBriefController.text = team.brief;
    _teamLeaderEmailController.text = team.teamLeaderEmail;
    _teamLeaderNameController.text = team.teamLeaderName;
    _teamDeputyController.text = team.deputyName;
    _teamMediaController.text = team.mediaName;
    _teamEconomicController.text = team.econmicName;
    teamController.teamLeaderEmail = team.teamLeaderEmail;
    teamController.teamLeaderName = team.teamLeaderName;
    teamController.teamLeaderID = team.teamLeaderID;
    currentTeamLeaderEmail = team.teamLeaderEmail;
    teamController.pickedImage.value = File('');
    teamCategory.value = team.category;
    if (team.teamLeaderID == FirebaseAuth.instance.currentUser!.uid) {
      teamController.isTeamLeaderEmailValid.value = true;
    }
  }
}
