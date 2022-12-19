import 'package:app/chances/view/edit_chance_page.dart';
import 'package:app/profile/controller/complete_profile_controller.dart';
import 'package:app/profile/view/complete_profile.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/dropdown_menu.dart';
import 'package:app/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const degreeChoicesList = [
  'أخرى',
  'ابتدائي',
  'متوسط',
  'ثانوي',
  'دبلوم',
  'بكالوريوس',
  'ماجستير',
  'دكتوراه',
];

const volunteerTypeList = [
  kChoose,
  'عادي',
  'مهاري',
  'احترافي',
];

const genderTypeList = [
  kChoose,
  'ذكر',
  'انثى',
];

class MandatoryProfileData extends StatelessWidget {
  MandatoryProfileData({
    Key? key,
  }) : super(key: key);

  var completeProfileController = Get.find<CompleteProfileController>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: completeProfileController.mandatoryFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.person,
                  color: kGreenColor,
                  size: 50,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'البيانات الأساسية',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: kGreenColor,
                  ),
                ),
                Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const Text('الاسم بالكامل'),
            MyTextField(
                controller: completeProfileController.nameController,
                validator: (input) {
                  if (input!.isEmpty) {
                    return kErrEmpty;
                  }
                }),
            const Text('رقم الجوال'),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                      controller: completeProfileController.phoneNoController,
                      isLTRdirection: true,
                      inputType: TextInputType.phone,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return kErrEmpty;
                        }
                        if (input.length < 6) {
                          return 'برجاء ادخال رقم الجوال';
                        }
                      }),
                ),
                SizedBox(width: 5.w),
                Text(
                  '🇸🇦 +966',
                  style: TextStyle(
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('تاريخ الميلاد'),
                      SizedBox(height: 4.h),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            onConfirm: (date) {
                              completeProfileController.userBirthday.value =
                                  "${date.day}-${date.month}-${date.year}";
                            },
                            onCancel: () {
                              completeProfileController.userBirthday.value = '';
                            },
                            currentTime: DateTime.now()
                                .subtract(const Duration(days: 10000)),
                            locale: LocaleType.ar,
                            theme: datePickerTheme,
                          );
                        },
                        child: Obx(
                          () => Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 40.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                )),
                            child: Text(
                              completeProfileController.userBirthday.value,
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('الجنس'),
                      Obx(
                        () => DropDownMenu(
                          fontSize: 17,
                          value: completeProfileController.genderType.value,
                          items: genderTypeList,
                          removeHeightPadding: true,
                          onChanged: (selectedValue) {
                            completeProfileController.genderType.value =
                                selectedValue ??
                                    completeProfileController.genderType.value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('المنطقة'),
                      MyTextField(
                          controller: completeProfileController.areaController,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return kErrEmpty;
                            }
                          }),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('المدينة'),
                      MyTextField(
                          controller: completeProfileController.cityController,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return kErrEmpty;
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المؤهل العلمي',
                        style: kTitleTextStyle,
                      ),
                      Obx(
                        () => DropDownMenu(
                          fontSize: 17,
                          value:
                              completeProfileController.educationDegree.value,
                          items: degreeChoicesList,
                          removeHeightPadding: true,
                          onChanged: (selectedValue) {
                            completeProfileController.educationDegree.value =
                                selectedValue ??
                                    completeProfileController
                                        .educationDegree.value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التخصص',
                        style: kTitleTextStyle,
                      ),
                      MyTextField(
                          controller:
                              completeProfileController.specializeController,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return kErrEmpty;
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              'مستوى التطوع',
              style: kTitleTextStyle,
            ),
            Obx(
              () => DropDownMenu(
                fontSize: 17,
                value: completeProfileController.volunteerLevel.value,
                items: volunteerTypeList,
                removeHeightPadding: true,
                onChanged: (selectedValue) {
                  completeProfileController.volunteerLevel.value =
                      selectedValue ??
                          completeProfileController.volunteerLevel.value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
