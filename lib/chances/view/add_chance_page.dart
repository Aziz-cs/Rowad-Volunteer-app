import 'dart:io';

import 'package:app/chances/controller/chances_controller.dart';
import 'package:app/profile/view/complete_profile.dart';
import 'package:app/profile/view/widgets/mandatory_profile_data.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../general/controller/image_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/dropdown_menu.dart';
import '../../widgets/simple_btn.dart';
import '../../widgets/textfield.dart';
import '../model/chance.dart';

const DatePickerTheme datePickerTheme = DatePickerTheme(
  doneStyle: TextStyle(color: Colors.white),
  cancelStyle: TextStyle(color: Colors.white),
  headerColor: kGreenColor,
);
const categoryNames = [
  'عام',
  'إجتماعي',
  'إداري',
  'إعلامي',
  'إسكاني',
  'إغاثة',
  'الأمن والسلامة',
  'السياحة',
  'بيئي',
  'تأهيلي',
  'تدريبي',
  'تربوي',
  'تعليمي',
  'ثقافى',
  'خدمي',
  'ديني',
  'رياضي',
  'صحي',
  'فني',
  'تقني',
  'قانوني',
  'مالي',
  'نفسي',
  'هندسة',
  'أخرى',
];

// const requiredDegrees = [
//   'غير مطلوب',
//   'دبلوم',
//   'بكالريوس',
//   'ماجستير',
//   'دكتوراة',
// ];

const kChooseCity = 'اختر المدينة';

class AddChance extends StatelessWidget {
  AddChance({
    Key? key,
  }) : super(key: key);

  ChancesController chancesController = Get.put(ChancesController());
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _organizationController = TextEditingController();
  final _sitNumbersController = TextEditingController();
  final _chanceURLController = TextEditingController();
  final category = 'عام'.obs;
  final requiredDegree = 'أخرى'.obs;
  final area = 'جازان'.obs;
  final city = kChoose.obs;
  final startDate = ''.obs;
  final endDate = ''.obs;
  late DateTime startDateTime;
  // late final XFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kGreenColor,
          title: const Text('إضافة فرصة تطوعية'),
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
                    'عنوان الفرصة',
                    style: kTitleTextStyle,
                  ),
                  MyTextField(
                    controller: _titleController,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return kErrEmpty;
                      }
                      if (input.length < 4) {
                        return kErrTooShort;
                      }
                    },
                  ),
                  Text(
                    'نبذة مختصرة',
                    style: kTitleTextStyle,
                  ),
                  MyTextField(
                    controller: _shortDescController,
                    maxLines: 4,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return kErrEmpty;
                      }
                      if (input.length < 10) {
                        return kErrTooShort;
                      }
                    },
                  ),
                  Text(
                    'الجهة المسؤولة',
                    style: kTitleTextStyle,
                  ),
                  MyTextField(
                    controller: _organizationController,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return kErrEmpty;
                      }
                      if (input.length < 2) {
                        return kErrTooShort;
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(
                          child: Divider(
                        color: kGreenColor,
                      )),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.w, vertical: 3),
                        child: Text('التصنيف',
                            style: TextStyle(
                              fontSize: 15.sp,
                              height: 1,
                            )),
                      ),
                      const Expanded(
                          child: Divider(
                        color: kGreenColor,
                      )),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'المنطقة',
                              style: kTitleTextStyle,
                            ),
                            FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('areas')
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  var result = snapshot.data;
                                  List<String> areaNames = [];
                                  result!.docs.forEach((element) {
                                    areaNames.add(element.id);
                                  });
                                  return Obx(
                                    () => DropDownMenu(
                                      fontSize: 17,
                                      value: area.value,
                                      items: areaNames,
                                      removeHeightPadding: true,
                                      onChanged: (selectedCity) {
                                        city.value = kChoose;
                                        area.value = selectedCity ?? area.value;
                                      },
                                    ),
                                  );
                                }
                                return CircularLoading();
                              },
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
                              'المدينة',
                              style: kTitleTextStyle,
                            ),
                            Obx(() => FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('areas')
                                      .doc(area.value)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      var result = snapshot.data;
                                      List<String> citiesList =
                                          List<String>.from((result!.data()
                                              as Map)['cities']);

                                      print('done:');
                                      return Obx(
                                        () => DropDownMenu(
                                          fontSize: 17,
                                          value: city.value,
                                          items: citiesList,
                                          removeHeightPadding: true,
                                          onChanged: (selectedValue) {
                                            city.value =
                                                selectedValue ?? city.value;
                                          },
                                        ),
                                      );
                                    }
                                    return CircularLoading();
                                  },
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'المؤهل العلمي',
                    style: kTitleTextStyle,
                  ),
                  Obx(
                    () => DropDownMenu(
                      fontSize: 17,
                      value: requiredDegree.value,
                      items: degreeChoicesList,
                      removeHeightPadding: true,
                      onChanged: (selectedValue) {
                        requiredDegree.value =
                            selectedValue ?? requiredDegree.value;
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('تاريخ البداية', style: kTitleTextStyle),
                            SizedBox(height: 4.h),
                            InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                DatePicker.showDatePicker(
                                  context,
                                  showTitleActions: true,
                                  minTime: DateTime.now(),
                                  onConfirm: (date) {
                                    endDate.value = '';
                                    startDateTime = date;
                                    startDate.value =
                                        "${date.day}-${date.month}-${date.year}";
                                    print('confirm $date');
                                  },
                                  onCancel: () {
                                    startDate.value = '';
                                  },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.ar,
                                  theme: datePickerTheme,
                                );
                              },
                              child: Obx(
                                () => Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 35.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: kGreenColor,
                                      )),
                                  child: Text(
                                    startDate.value,
                                    style: TextStyle(
                                      color: kGreenColor,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          children: [
                            Text('تاريخ النهاية', style: kTitleTextStyle),
                            SizedBox(height: 4.h),
                            GestureDetector(
                              onTap: () {
                                if (startDate.value.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'برجاء إختيار تاريخ البداية أولا');
                                  return;
                                }
                                FocusScope.of(context).unfocus();
                                DatePicker.showDatePicker(
                                  context,
                                  showTitleActions: true,
                                  minTime: startDateTime,
                                  onConfirm: (date) {
                                    endDate.value =
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
                                    height: 35.h,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: Colors.red.shade800,
                                        )),
                                    child: Text(
                                      endDate.value,
                                      style: TextStyle(
                                        color: Colors.red.shade800,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('المقاعد', style: kTitleTextStyle),
                            MyTextField(
                              inputType: TextInputType.number,
                              controller: _sitNumbersController,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return kErrEmpty;
                                }
                              },
                              hintText: 'العدد',
                              isLabelCentered: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          children: [
                            Text('المجال', style: kTitleTextStyle),
                            Obx(() => DropDownMenu(
                                  value: category.value,
                                  fontSize: 17,
                                  items: categoryNames,
                                  removeHeightPadding: true,
                                  onChanged: (selectedValue) {
                                    category.value =
                                        selectedValue ?? category.value;
                                  },
                                )),
                          ],
                        ),
                      ),
                      SizedBox(width: 3.w),
                    ],
                  ),
                  Text(
                    'الجنس',
                    style: kTitleTextStyle,
                  ),
                  _buildSelectGender(),
                  _aDivider(),
                  Text(
                    'نوع  المشاركة',
                    style: kTitleTextStyle,
                  ),
                  _buildTwoRadioBtnsOnly(
                    firstLabel: 'فردي',
                    secondLabel: 'جماعي',
                    isGroupValueFirstChoice: false,
                    rxBool: chancesController.isTeamWork,
                  ),
                  _aDivider(),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'عاجلة',
                                style: kTitleTextStyle,
                              ),
                              _buildTwoRadioBtnsOnly(
                                firstLabel: 'نعم',
                                secondLabel: 'لا',
                                isGroupValueFirstChoice: true,
                                rxBool: chancesController.isUrgent,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'عن بعد',
                                style: kTitleTextStyle,
                              ),
                              _buildTwoRadioBtnsOnly(
                                firstLabel: 'نعم',
                                secondLabel: 'لا',
                                isGroupValueFirstChoice: true,
                                rxBool: chancesController.isOnline,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _aDivider(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تدعم ذوي الإعاقة',
                              style: kTitleTextStyle,
                            ),
                            _buildTwoRadioBtnsOnly(
                              firstLabel: 'نعم',
                              secondLabel: 'لا',
                              isGroupValueFirstChoice: true,
                              rxBool: chancesController.isSupportDisabled,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تتطلب مقابلة',
                              style: kTitleTextStyle,
                            ),
                            _buildTwoRadioBtnsOnly(
                              firstLabel: 'نعم',
                              secondLabel: 'لا',
                              isGroupValueFirstChoice: true,
                              rxBool: chancesController.isNeedInterview,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _aDivider(),
                  Text(
                    'الصورة',
                    style: kTitleTextStyle,
                  ),
                  SimpleButton(
                    label: 'أختر الصورة',
                    onPress: () async {
                      chancesController.pickedImage.value =
                          await ImageController.pickImage();
                    },
                  ),
                  Obx(
                    () => chancesController.pickedImage.value.path.isEmpty
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.file(
                                File(chancesController.pickedImage.value.path),
                                width: 250.w,
                              ),
                            ],
                          ),
                  ),
                  _aDivider(),
                  Text(
                    'رابط الفرصة على المنصة',
                    style: kTitleTextStyle,
                  ),
                  MyTextField(
                    isLTRdirection: true,
                    controller: _chanceURLController,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return kErrEmpty;
                      }
                      if (!GetUtils.isURL(input)) {
                        return kErrInvalidURL;
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  Obx(() => chancesController.isLoading.isTrue
                      ? Center(child: CircularLoading())
                      : SimpleButton(
                          label: 'اضف الفرصة',
                          onPress: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            if (city.value == kChooseCity) {
                              Fluttertoast.showToast(
                                msg: 'برجاء إختيار المدينة',
                              );
                            }
                            if (startDate.value.isEmpty &&
                                endDate.value.isEmpty) {
                              Fluttertoast.showToast(
                                msg: 'برجاء إختيار تاريخ بداية ونهاية الفرصة',
                                toastLength: Toast.LENGTH_LONG,
                              );
                              return;
                            }
                            if (startDate.value.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'برجاء إختيار تاريخ البداية');
                              return;
                            }
                            if (endDate.value.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'برجاء إختيار تاريخ النهاية');
                              return;
                            }
                            if (chancesController
                                .pickedImage.value.path.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'برجاء رفع صورة للخبر');
                              return;
                            }

                            if (chancesController
                                .pickedImage.value.path.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'برجاء رفع صورة للخبر');
                              return;
                            }

                            Chance chance = Chance(
                              title: _titleController.text.trim(),
                              shortDesc: _shortDescController.text.trim(),
                              organization: _organizationController.text.trim(),
                              startDate: startDate.value,
                              endDate: endDate.value,
                              area: area.value,
                              city: city.value,
                              sitsNo: _sitNumbersController.text.trim(),
                              category: category.value,
                              requiredDegree: requiredDegree.value,
                              gender: chancesController.getGenderType(
                                  chancesController.genderType.value),
                              isTeamWork: chancesController.isTeamWork.value,
                              isUrgent: chancesController.isUrgent.value,
                              isOnline: chancesController.isOnline.value,
                              isSupportDisabled:
                                  chancesController.isSupportDisabled.value,
                              isNeedInterview:
                                  chancesController.isNeedInterview.value,
                              chanceURL: _chanceURLController.text.trim(),
                              id: '',
                              imageURL: '',
                              imagePath: '',
                              timestamp: Timestamp.now(),
                            );
                            chancesController.addModifyChance(chance: chance);
                          },
                        )),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ));
  }

  Divider _aDivider() {
    return const Divider(color: Colors.grey);
  }

  Row _buildSelectGender() {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => RadioListTile<Gender>(
              activeColor: kGreenColor,
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                'ذكور',
                style: TextStyle(
                  fontSize: 15.sp,
                ),
              ),
              value: Gender.males,
              groupValue: chancesController.genderType.value,
              onChanged: (value) {
                chancesController.genderType.value = value ?? Gender.males;
              },
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => RadioListTile<Gender>(
              activeColor: kGreenColor,
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                'إناث',
                style: TextStyle(
                  fontSize: 15.sp,
                ),
              ),
              value: Gender.females,
              groupValue: chancesController.genderType.value,
              onChanged: (value) {
                chancesController.genderType.value = value ?? Gender.females;
              },
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => RadioListTile<Gender>(
              contentPadding: EdgeInsets.zero,
              activeColor: kGreenColor,
              dense: true,
              title: Text(
                'الجنسين',
                style: TextStyle(
                  fontSize: 15.sp,
                ),
              ),
              value: Gender.both,
              groupValue: chancesController.genderType.value,
              onChanged: (value) {
                chancesController.genderType.value = value ?? Gender.both;
              },
            ),
          ),
        ),
      ],
    );
  }

  Row _buildTwoRadioBtnsOnly({
    required String firstLabel,
    required String secondLabel,
    required isGroupValueFirstChoice,
    required RxBool rxBool,
  }) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => RadioListTile(
              activeColor: kGreenColor,
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                firstLabel,
                style: TextStyle(
                  fontSize: 15.sp,
                ),
              ),
              value: rxBool.value,
              groupValue: isGroupValueFirstChoice,
              onChanged: (_) {
                rxBool.value = !rxBool.value;
              },
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => RadioListTile(
              activeColor: kGreenColor,
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                secondLabel,
                style: TextStyle(
                  fontSize: 15.sp,
                ),
              ),
              value: rxBool.value,
              groupValue: !isGroupValueFirstChoice,
              onChanged: (value) {
                rxBool.value = !rxBool.value;
              },
            ),
          ),
        ),
      ],
    );
  }
}
