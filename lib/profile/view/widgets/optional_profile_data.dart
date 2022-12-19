import 'package:app/chances/view/edit_chance_page.dart';
import 'package:app/profile/controller/complete_profile_controller.dart';
import 'package:app/profile/view/complete_profile.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/dropdown_menu.dart';
import 'package:app/widgets/simple_btn.dart';
import 'package:app/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

var workTypeList = [
  kChoose,
  'طالب',
  'متقاعد',
  'قطاع حكومي',
  'أخرى',
  'قطاع خاص',
  'قطاع غير ربحي',
];

const langLevelList = [
  kChoose,
  'ممتاز',
  'جيد',
  'ليس سيئ',
];

const String kSkillDefault = 'قائمة المهارات';
const String kInterestsDefault = 'اختر الإهتمامات';

class OptionalProfileData extends StatelessWidget {
  OptionalProfileData({
    Key? key,
  }) : super(key: key);
  var completeProfileController = Get.find<CompleteProfileController>();

  List<String> languagesList = [
    'العربية',
    'الإنجليزية',
    'الفرنسية',
    'الألمانية',
    'الإيطالية',
  ];

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
    'عام',
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
    'إعلامي',
    'السياحة',
    'خدمة ضيوف الرحمن',
    'تأهيلي',
    'تنظيمي',
  ].obs;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: completeProfileController.optionalFromKey,
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
                  'البيانات الاختيارية',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: kGreenColor,
                  ),
                ),
              ],
            ),
            const Text('رقم الهوية'),
            MyTextField(
                inputType: TextInputType.number,
                controller: completeProfileController.nationalIDController,
                validator: (input) {}),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('الجنسية'),
                    MyTextField(
                        controller:
                            completeProfileController.nationalityController,
                        validator: (input) {
                          if (input!.isEmpty) {
                            return kErrEmpty;
                          }
                        }),
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('الحالة الاجتماعية'),
                    MyTextField(
                        controller:
                            completeProfileController.socialStateController,
                        validator: (input) {
                          if (input!.isEmpty) {
                            return kErrEmpty;
                          }
                        }),
                  ],
                )),
              ],
            ),
            SizedBox(width: 5.w),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('قطاع العمل'),
                      Obx(
                        () => DropDownMenu(
                          fontSize: 17,
                          value: completeProfileController.workType.value,
                          items: workTypeList,
                          removeHeightPadding: true,
                          onChanged: (selectedValue) {
                            completeProfileController.workType.value =
                                selectedValue ??
                                    completeProfileController.workType.value;
                          },
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
                      const Text('المهنة'),
                      MyTextField(
                          controller: completeProfileController.jobController,
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
                      const Text('اللغة'),
                      Obx(
                        () => DropDownMenu(
                          fontSize: 17,
                          value: completeProfileController.language.value,
                          items: languagesList,
                          removeHeightPadding: true,
                          onChanged: (selectedValue) {
                            completeProfileController.language.value =
                                selectedValue ??
                                    completeProfileController.language.value;
                          },
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
                      const Text('درجة الإتقان'),
                      Obx(
                        () => DropDownMenu(
                          fontSize: 17,
                          value: completeProfileController.langLevel.value,
                          items: langLevelList,
                          removeHeightPadding: true,
                          onChanged: (selectedValue) {
                            completeProfileController.langLevel.value =
                                selectedValue ??
                                    completeProfileController.langLevel.value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SimpleButton(
                  label: 'اضافة',
                  onPress: () {
                    if (completeProfileController.langLevel.value == kChoose) {
                      Fluttertoast.showToast(msg: 'برجاء اختيار درجة الإتقان');
                      return;
                    }
                    completeProfileController.userLanguageMap.putIfAbsent(
                        completeProfileController.language.value,
                        () => completeProfileController.langLevel.value);
                    languagesList
                        .remove(completeProfileController.language.value);
                    completeProfileController.language.value =
                        languagesList.first;
                    completeProfileController.langLevel.value = kChoose;
                    print(completeProfileController.userLanguageMap);
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(
                () => Column(
                  children: List.generate(
                    completeProfileController.userLanguageMap.length,
                    (index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          completeProfileController.userLanguageMap.keys
                              .elementAt(index),
                        ),
                        Text(
                          completeProfileController.userLanguageMap.values
                              .elementAt(index),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.xmark,
                            color: Colors.red,
                            size: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => DropDownMenu(
                fontSize: 17,
                value: completeProfileController.skill.value,
                items: skillsList,
                removeHeightPadding: true,
                onChanged: (selectedValue) {
                  completeProfileController.skill.value =
                      selectedValue ?? completeProfileController.skill.value;
                  if (completeProfileController.skill.value == kSkillDefault) {
                    return;
                  }

                  completeProfileController.usersSkillsList
                      .add(completeProfileController.skill.value);
                  skillsList.remove(completeProfileController.skill.value);
                  completeProfileController.skill.value = kSkillDefault;
                  print(completeProfileController.usersSkillsList);
                },
              ),
            ),
            Obx(() => Wrap(
                  children: List.generate(
                      completeProfileController.usersSkillsList.length,
                      (index) => InkWell(
                            onTap: () {
                              skillsList.add(completeProfileController
                                  .usersSkillsList[index]);
                              completeProfileController.usersSkillsList.remove(
                                  completeProfileController
                                      .usersSkillsList[index]);
                              skillsList.refresh();
                              completeProfileController.usersSkillsList
                                  .refresh();
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
                                  SizedBox(width: 5.w),
                                  Text(
                                    completeProfileController
                                        .usersSkillsList[index],
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
            Obx(
              () => DropDownMenu(
                fontSize: 17,
                value: completeProfileController.interest.value,
                items: interestsList,
                removeHeightPadding: true,
                onChanged: (selectedValue) {
                  completeProfileController.interest.value =
                      selectedValue ?? completeProfileController.interest.value;
                  if (completeProfileController.interest.value ==
                      kInterestsDefault) {
                    return;
                  }

                  completeProfileController.usersInterestsList
                      .add(completeProfileController.interest.value);
                  interestsList
                      .remove(completeProfileController.interest.value);
                  completeProfileController.interest.value = kInterestsDefault;
                },
              ),
            ),
            Obx(() => Wrap(
                  children: List.generate(
                      completeProfileController.usersInterestsList.length,
                      (index) => InkWell(
                            onTap: () {
                              interestsList.add(completeProfileController
                                  .usersInterestsList[index]);
                              completeProfileController.usersInterestsList
                                  .remove(completeProfileController
                                      .usersInterestsList[index]);
                              interestsList.refresh();
                              completeProfileController.usersInterestsList
                                  .refresh();
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
                                  SizedBox(width: 5.w),
                                  Text(
                                    completeProfileController
                                        .usersInterestsList[index],
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
        ),
      ),
    );
  }
}
