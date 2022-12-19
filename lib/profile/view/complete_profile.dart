import 'package:app/profile/controller/complete_profile_controller.dart';
import 'package:app/profile/model/volunteer.dart';
import 'package:app/profile/view/widgets/mandatory_profile_data.dart';
import 'package:app/profile/view/widgets/optional_profile_data.dart';
import 'package:app/start/splash_page.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:app/widgets/navigator_page.dart';
import 'package:app/widgets/simple_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CompleteProfile extends StatelessWidget {
  CompleteProfile({super.key});

  var completeProfileController = Get.put(CompleteProfileController());

  final _pageViewController = PageController(initialPage: 0, keepPage: false);
  final currentPage = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kGreenColor,
          leadingWidth: 100.w,
          leading: InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.offAll(() => SplashPage());
            },
            child: Row(
              children: [
                const SizedBox(width: 6),
                const Icon(
                  Icons.logout,
                  size: 17,
                ),
                const SizedBox(width: 4),
                Text(
                  'تسجيل خروج',
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            'تكملة البيانات',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    onPageChanged: (value) {
                      print('value changed to: $value');
                      currentPage.value = value;
                    },
                    controller: _pageViewController,
                    children: [
                      MandatoryProfileData(),
                      OptionalProfileData(),
                    ],
                  ),
                ),
                Obx(
                  () => currentPage.value == 0
                      ? const SizedBox()
                      : CheckboxListTile(
                          activeColor: kGreenColor,
                          title:
                              const Text('أوافق على شروط وإتفاقية الإستخدام'),
                          value: completeProfileController.isAgreeTerms.value,
                          onChanged: (value) {
                            completeProfileController.isAgreeTerms.value =
                                value!;
                          },
                        ),
                ),
                Obx(() => Visibility(
                      visible: currentPage.value == 1,
                      child: Obx(() => completeProfileController
                              .isLoadingSavingProfileData.isTrue
                          ? const CircularLoading()
                          : SimpleButton(
                              label: 'حفظ البيانات والبدء',
                              onPress: () {
                                if (completeProfileController
                                    .isAgreeTerms.isFalse) {
                                  Fluttertoast.showToast(
                                      msg:
                                          'برجاء الموافقة على شروط وإتفاقية الإستخدام');
                                  return;
                                }
                                completeProfileController.submitProfileData();
                              },
                            )),
                    )),
                Obx(() => currentPage.value == 0
                    ? SimpleButton(
                        label: 'التالي',
                        onPress: () async {
                          print('next clicked');
                          if (!completeProfileController
                              .mandatoryFormKey.currentState!
                              .validate()) {
                            return;
                          }

                          if (completeProfileController
                              .isMandatoryFieldsNotValid()) {
                            return;
                          }
                          _pageViewController.animateToPage(
                              currentPage.value + 1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        })
                    : SimpleButton(
                        label: 'السابق',
                        onPress: () async {
                          _pageViewController.animateToPage(
                              currentPage.value - 1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        })),
                SizedBox(height: 10.h),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDot(isSelected: currentPage.value == 0),
                        _buildDot(isSelected: currentPage.value == 1),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildDot({
  required bool isSelected,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 1.w),
    child: Row(
      children: [
        Container(
          width: 19.w,
          height: 5.h,
          decoration: BoxDecoration(
              color: isSelected ? kGreenColor : Colors.green.shade200,
              borderRadius: BorderRadius.circular(10)),
        ),
      ],
    ),
  );
}
