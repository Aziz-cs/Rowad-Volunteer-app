import 'dart:io';

import 'package:app/news/controller/news_controller.dart';
import 'package:app/news/model/news.dart';
import 'package:app/teams/controller/team_controller.dart';
import 'package:app/teams/model/team.dart';
import 'package:app/teams/view/wysiwyg_editor_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class AddTeamPage extends StatelessWidget {
  AddTeamPage({Key? key}) : super(key: key);
  final teamController = Get.put(TeamController());

  quill.QuillController _controller = quill.QuillController.basic();

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
  final teamCategory = '- أختر -'.obs;

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
                    if (input!.isEmpty) {
                      return kErrEmpty;
                    }
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
                    if (input!.isEmpty) {
                      return kErrEmpty;
                    }
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
                                    onChanged: (selectedCategory) {
                                      teamCategory.value = selectedCategory ??
                                          teamCategory.value;
                                    },
                                  ));
                            }
                            return const Center(child: CircularLoading());
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
                _buildAddUserRoleToTeam(
                  userRole: 'البريد الألكتروني لقائد الفريق',
                  isLTRdirection: true,
                  hintText: 'البريد المسجل به العضو',
                  controller: _teamLeaderEmailController,
                ),
                _buildAddUserRoleToTeam(
                  userRole: 'قائد الفريق',
                  controller: _teamLeaderNameController,
                ),
                _buildAddUserRoleToTeam(
                  userRole: 'نائب الفريق',
                  controller: _teamDeputyController,
                ),
                _buildAddUserRoleToTeam(
                  userRole: 'العضو الإعلامي',
                  controller: _teamMediaController,
                ),
                _buildAddUserRoleToTeam(
                  userRole: 'العضو المالي',
                  controller: _teamEconomicController,
                ),
                SizedBox(height: 5.h),
                Obx(() => teamController.isLoading.isTrue
                    ? const Center(child: CircularLoading())
                    : SimpleButton(
                        label: 'إضافة الفريق',
                        onPress: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          if (teamController.pickedImage.value.path.isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'برجاء رفع صورة للفريق');
                            return;
                          }
                          if (teamCategory.value == kChooseCategory) {
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
                                _teamLeaderEmailController.text.trim(),
                            teamLeaderName:
                                _teamLeaderNameController.text.trim(),
                            deputyName: _teamDeputyController.text.trim(),
                            mediaName: _teamMediaController.text.trim(),
                            econmicName: _teamEconomicController.text.trim(),
                            id: '',
                            imageURL: '',
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

  Column _buildAddUserRoleToTeam({
    required String userRole,
    String hintText = 'الأسم',
    bool isLTRdirection = false,
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
                isLTRdirection: isLTRdirection,
                controller: controller,
                hintText: hintText,
                validator: (input) {
                  if (input!.isEmpty) {
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
                              (index) => result[index]['name'] ==
                                      kChooseCategory
                                  ? const SizedBox()
                                  : ListTile(
                                      title: Text(result[index]['name']),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          CupertinoIcons.xmark,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('general_categories')
                                              .doc(result[index].id)
                                              .delete();
                                          Fluttertoast.showToast(
                                              msg: 'تم حذف التصنيف');
                                        },
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      );
                    }
                    return const Center(child: CircularLoading());
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
                      ? const CircularLoading()
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

  void clearProperties() {
    // newsController.photoAlbum.clear();
    // newsController.pickedImage.value = File('');
  }
}
