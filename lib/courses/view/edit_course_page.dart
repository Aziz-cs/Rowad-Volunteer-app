import 'dart:io';

import 'package:app/courses/controller/course_controller.dart';
import 'package:app/courses/model/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../chances/view/add_chance_page.dart';
import '../../general/controller/image_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/circular_loading.dart';
import '../../widgets/dropdown_menu.dart';
import '../../widgets/simple_btn.dart';
import '../../widgets/textfield.dart';
import 'courses_page.dart';

const String kChooseCategory = '- أختر -';
const List<String> hourIntervals = [
  '12:00',
  '12:30',
  '01:00',
  '01:30',
  '02:00',
  '02:30',
  '03:00',
  '03:30',
  '04:00',
  '04:30',
  '05:00',
  '05:30',
  '06:00',
  '06:30',
  '07:00',
  '07:30',
  '08:00',
  '08:30',
  '09:00',
  '09:30',
  '10:00',
  '10:30',
  '11:00',
  '11:30',
];

const List<String> timeZoneList = [
  'صباحا',
  'مساء',
];

class EditCoursePage extends StatelessWidget {
  EditCoursePage({
    Key? key,
    required this.course,
  }) : super(key: key);
  final Course course;
  final coursesController = Get.put(CoursesController());
  final _formKey = GlobalKey<FormState>();

  final _courseNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _instructorNameController = TextEditingController();
  final _courseIntroController = TextEditingController();
  final _courseDetailsController = TextEditingController();
  final _durationInDaysController = TextEditingController();

  final isRegisterationOpen = true.obs;
  final startDate = ''.obs;
  final startHour = '12:00'.obs;
  final isAMorPM = 'صباحا'.obs;

  // late final XFile? pickedImage;
  @override
  Widget build(BuildContext context) {
    setProperties();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: kGreenColor,
            title: const Text('إضافة دورة تدريبية'),
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
                      'اسم البرنامج التدريبي',
                      style: kTitleTextStyle,
                    ),
                    MyTextField(
                      controller: _courseNameController,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return kErrEmpty;
                        }
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'الجهة المقدمة للبرنامج',
                                style: kTitleTextStyle,
                              ),
                              MyTextField(
                                controller: _ownerNameController,
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return kErrEmpty;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'مقدم البرنامج التدريبي',
                                style: kTitleTextStyle,
                              ),
                              MyTextField(
                                controller: _instructorNameController,
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return kErrEmpty;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'نبذة عن البرنامج',
                      style: kTitleTextStyle,
                    ),
                    MyTextField(
                      inputAction: TextInputAction.newline,
                      inputType: TextInputType.multiline,
                      controller: _courseIntroController,
                      maxLines: 2,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return kErrEmpty;
                        }
                      },
                    ),
                    Text(
                      'تفاصيل البرنامج',
                      style: kTitleTextStyle,
                    ),
                    MyTextField(
                      inputAction: TextInputAction.newline,
                      inputType: TextInputType.multiline,
                      controller: _courseDetailsController,
                      maxLines: 4,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return kErrEmpty;
                        }
                      },
                    ),
                    Obx(() => SwitchListTile.adaptive(
                          activeColor: kGreenColor,
                          value: isRegisterationOpen.value,
                          onChanged: (_) {
                            isRegisterationOpen.value =
                                !isRegisterationOpen.value;
                          },
                          title: Text(
                            'التسجيل',
                            style: TextStyle(
                              fontSize: 16.sp,
                            ),
                          ),
                        )),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('تاريخ البدء', style: kTitleTextStyle),
                              SizedBox(height: 4.h),
                              GestureDetector(
                                onTap: () {
                                  DatePicker.showDatePicker(
                                    context,
                                    showTitleActions: true,
                                    minTime: DateTime.now(),
                                    onConfirm: (date) {
                                      startDate.value =
                                          "${date.day}-${date.month}-${date.year}";
                                    },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.ar,
                                    theme: datePickerTheme,
                                  );
                                },
                                child: Obx(() => Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      height: 41.h,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: kGreenColor.withOpacity(0.5),
                                          )),
                                      child: Text(
                                        startDate.value,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'عدد الأيام',
                                style: kTitleTextStyle,
                              ),
                              MyTextField(
                                inputType: TextInputType.number,
                                controller: _durationInDaysController,
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return kErrEmpty;
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(
                      'الوقت',
                      style: kTitleTextStyle,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => DropDownMenu(
                              fontSize: 17,
                              value: startHour.value,
                              items: hourIntervals,
                              removeHeightPadding: true,
                              onChanged: (pickedHour) {
                                startHour.value = pickedHour ?? startHour.value;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () => DropDownMenu(
                              fontSize: 17,
                              value: isAMorPM.value,
                              items: timeZoneList,
                              removeHeightPadding: true,
                              onChanged: (pickedZone) {
                                isAMorPM.value = pickedZone ?? isAMorPM.value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'الصورة البارزة',
                      style: kTitleTextStyle,
                    ),
                    SimpleButton(
                        label: 'تغيير الصورة',
                        onPress: () async {
                          coursesController.pickedImage.value =
                              await ImageController.pickImage();
                        }),
                    Obx(
                      () => coursesController.pickedImage.value.path.isEmpty
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.file(
                                  File(
                                      coursesController.pickedImage.value.path),
                                  width: 250.w,
                                ),
                              ],
                            ),
                    ),
                    Obx(() => coursesController.isLoading.isTrue
                        ? const Center(child: CircularLoading())
                        : SimpleButton(
                            label: 'تعديل الدورة التدريبية',
                            onPress: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              Course editedCourse = Course(
                                name: _courseNameController.text.trim(),
                                intro: _courseIntroController.text.trim(),
                                details: _courseDetailsController.text.trim(),
                                owner: _ownerNameController.text.trim(),
                                instructorName:
                                    _instructorNameController.text.trim(),
                                startDate: startDate.value,
                                duration: _durationInDaysController.text.trim(),
                                isRegisterationOpen: isRegisterationOpen.value,
                                startHour: startHour.value,
                                isAMorPM: isAMorPM.value,
                                id: course.id,
                                imageURL: course.imageURL,
                                imagePath: course.imagePath,
                                registerationURL: course.registerationURL,
                                timestamp: course.timestamp,
                              );
                              coursesController.addModifyCourses(
                                course: editedCourse,
                                isModifing: true,
                                isPicChanged: coursesController
                                    .pickedImage.value.path.isNotEmpty,
                              );
                            },
                          )),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void setProperties() {
    _courseDetailsController.text = course.details;
    _courseIntroController.text = course.intro;
    _courseNameController.text = course.name;
    _durationInDaysController.text = course.duration;
    _instructorNameController.text = course.instructorName;
    _ownerNameController.text = course.owner;

    isRegisterationOpen.value = course.isRegisterationOpen;
    startDate.value = course.startDate;
    startHour.value = course.startHour;
    isAMorPM.value = course.isAMorPM;
  }
}
