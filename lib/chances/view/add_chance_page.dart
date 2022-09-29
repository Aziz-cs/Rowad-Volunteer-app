import 'package:app/chances/controller/add_chance_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/constants.dart';
import '../../widgets/dropdown_menu.dart';
import '../../widgets/simple_btn.dart';
import '../../widgets/textfield.dart';

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

const requiredDegrees = [
  'غير مطلوب',
  'دبلوم',
  'بكالريوس',
  'ماجستير',
  'دكتوراة',
];

class AddChance extends StatelessWidget {
  AddChance({Key? key}) : super(key: key);

  AddChanceController addChanceController = Get.put(AddChanceController());

  final _titleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _locationController = TextEditingController();
  final _organizeController = TextEditingController();
  final _sitNumbersController = TextEditingController();
  final category = 'عام'.obs;
  final requiredDegree = 'غير مطلوب'.obs;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'عنوان الفرصة',
                  style: kTitleTextStyle,
                ),
                MyTextField(
                  controller: _titleController,
                  validator: (input) {},
                ),
                Text(
                  'تفاصيل الفرصة التطوعية',
                  style: kTitleTextStyle,
                ),
                MyTextField(
                  controller: _titleController,
                  validator: (input) {},
                ),
                Text('التصنيف', style: kTitleTextStyle),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('تاريخ البداية', style: kTitleTextStyle),
                          MyTextField(
                            controller: _startDateController,
                            validator: (input) {},
                            isLabelCentered: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        children: [
                          Text('تاريخ النهاية', style: kTitleTextStyle),
                          MyTextField(
                            controller: _endDateController,
                            validator: (input) {},
                            isLabelCentered: true,
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
                        children: [
                          Text('المكان', style: kTitleTextStyle),
                          MyTextField(
                            controller: _locationController,
                            validator: (input) {},
                            label: 'المدينة',
                            isLabelCentered: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        children: [
                          Text('الجهة', style: kTitleTextStyle),
                          MyTextField(
                            controller: _organizeController,
                            validator: (input) {},
                            label: 'الجهة المسؤولة',
                            isLabelCentered: true,
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
                        children: [
                          Text('المقاعد', style: kTitleTextStyle),
                          MyTextField(
                            inputType: TextInputType.number,
                            controller: _sitNumbersController,
                            validator: (input) {},
                            label: 'العدد',
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
                                onChanged: (selectedCategory) {
                                  category.value =
                                      selectedCategory ?? category.value;
                                },
                              )),
                        ],
                      ),
                    ),
                    SizedBox(width: 3.w),
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
                    items: requiredDegrees,
                    removeHeightPadding: true,
                    onChanged: (selectedCategory) {
                      requiredDegree.value =
                          selectedCategory ?? requiredDegree.value;
                    },
                  ),
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
                  rxBool: addChanceController.isTeamWork,
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
                              rxBool: addChanceController.isUrgent,
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
                              rxBool: addChanceController.isOnline,
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
                            rxBool: addChanceController.isSupportDisabled,
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
                            rxBool: addChanceController.isNeedInterview,
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
                    final ImagePicker _picker = ImagePicker();

                    final XFile? pickedImage =
                        await _picker.pickImage(source: ImageSource.gallery);
                  },
                ),
                // Container(
                //   child: pickedImage != null
                //       ? Image.file(File(pickedImage!.path), height: 100)
                //       : Text("Pick up the  image"),
                // ),
                _aDivider(),
                Text(
                  'رابط الفرصة على المنصة',
                  style: kTitleTextStyle,
                ),
                MyTextField(
                  controller: _titleController,
                  validator: (input) {},
                ),
                SizedBox(height: 10.h),
                SimpleButton(
                  label: 'اضف الفرصة',
                  onPress: () {},
                ),
                SizedBox(height: 20.h),
              ],
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
              value: Gender.male,
              groupValue: addChanceController.genderType.value,
              onChanged: (value) {
                addChanceController.genderType.value = value ?? Gender.male;
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
              value: Gender.female,
              groupValue: addChanceController.genderType.value,
              onChanged: (value) {
                addChanceController.genderType.value = value ?? Gender.female;
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
              groupValue: addChanceController.genderType.value,
              onChanged: (value) {
                addChanceController.genderType.value = value ?? Gender.both;
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
              groupValue: false,
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
              groupValue: true,
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
