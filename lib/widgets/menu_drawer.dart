import 'dart:io';

import 'package:app/admin/view/admin_panel_page.dart';
import 'package:app/chances/view/chances_page.dart';
import 'package:app/courses/view/courses_page.dart';
import 'package:app/main.dart';
import 'package:app/news/view/news_page.dart';
import 'package:app/start/splash_page.dart';
import 'package:app/teams/view/teams_page.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/simple_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../utils/helper.dart';
import 'navigator_page.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: kOffWhite,
        child: Column(
          children: [
            Container(
              color: kGreenColor,
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage:
                          Image.asset("assets/images/avatar.png").image,
                    ),
                  ),
                  SizedBox(width: 9.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحبا',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        'بالضــيف',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  menuListItem(
                    itemName: 'الرئيسية',
                    icon: CupertinoIcons.home,
                    onPress: () {
                      Get.offAll(
                        () => NavigatorPage(),
                        duration: const Duration(microseconds: 1),
                      );
                    },
                  ),
                  menuListItem(
                    itemName: 'الفرص التطوعية',
                    icon: CupertinoIcons.news_solid,
                    onPress: () {
                      Get.offAll(
                        () => NavigatorPage(tabIndex: 1),
                        duration: const Duration(microseconds: 1),
                      );
                    },
                  ),
                  menuListItem(
                      itemName: 'المركز الإعلامي',
                      icon: Icons.newspaper,
                      onPress: () {
                        Get.offAll(
                          () => NavigatorPage(tabIndex: 2),
                          duration: const Duration(microseconds: 1),
                        );
                      }),
                  menuListItem(
                      itemName: 'الفرق التطوعية',
                      icon: Icons.group,
                      onPress: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: TeamsPage(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      }),
                  menuListItem(
                      itemName: 'الدورات التدريبية',
                      icon: Icons.class_,
                      onPress: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: CoursesPage(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      }),
                  menuListItem(
                    itemName: 'أخرى',
                    icon: CupertinoIcons.circle_grid_3x3_fill,
                    onPress: () {
                      Get.offAll(
                        () => NavigatorPage(tabIndex: 3),
                        duration: const Duration(microseconds: 1),
                      );
                    },
                  ),
                  menuListItem(
                      itemName: 'عن التطبيق',
                      imgPath: 'menu_msgs',
                      icon: Icons.perm_device_information,
                      onPress: () {
                        Get.defaultDialog(
                            titlePadding: EdgeInsets.zero,
                            title: '',
                            contentPadding: const EdgeInsets.all(10),
                            content: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 6.h),
                                  Text(
                                    'عن التطبيق:-',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: kGreenColor,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: SingleChildScrollView(
                                          child: Text(
                                            appDesc,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 3.h),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50),
                                    child: SimpleButton(
                                      isCurved: false,
                                      label: 'تواصل معنا',
                                      onPress: () {
                                        final Uri _emailLaunchUri = Uri(
                                          scheme: 'mailto',
                                          path: 'Rowad@gmail.com',
                                        );
                                        openUrl(_emailLaunchUri.toString());
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'الإصدار ',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      Text(
                                        appVersion,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: kGreenColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     final Uri _emailLaunchUri = Uri(
                                  //       scheme: 'mailto',
                                  //       path: 'Aziz.egy@gmail.com',
                                  //     );
                                  //     openUrl(_emailLaunchUri.toString());
                                  //   },
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                  //     children: [
                                  //       Text(
                                  //         '   تم التطوير بــ',
                                  //         style: TextStyle(
                                  //           fontSize: 15.sp,
                                  //         ),
                                  //       ),
                                  //       SizedBox(width: 2.w),
                                  //       Text(
                                  //         "Aziz.cs",
                                  //         style: TextStyle(
                                  //           fontSize: 16.sp,
                                  //           decoration: TextDecoration.underline,
                                  //           color: kGreenColor,
                                  //           fontWeight: FontWeight.w500,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ));
                      }),
                  // const Divider(color: Colors.grey),
                  menuListItem(
                    itemName: 'لوحة التحكم',
                    icon: Icons.admin_panel_settings_outlined,
                    onPress: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: AdminPanelPage(),
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                  ),
                  menuListItem(
                    icon: Icons.logout,
                    itemName: 'تسجيل خروج',
                    onPress: () {
                      print('signing out');
                      FirebaseAuth.instance.signOut();
                      Get.offAll(() => SplashPage());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuListItem({
    required String itemName,
    required VoidCallback onPress,
    required IconData icon,
    String imgPath = '',
    bool isDiffColor = false,
    bool isIcon = true,
  }) {
    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: ListTile(
              leading: Container(
                width: 35.w,
                height: 35.h,
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: isIcon
                    ? Icon(
                        icon,
                        size: 20.w,
                        color: Colors.brown.shade900,
                      )
                    : Image.asset(
                        imgPath,
                        width: 18.w,
                        height: 18.h,
                      ),
              ),
              dense: true,
              title: Text(
                itemName,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.5.sp,
                  height: 1,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
              onTap: onPress,
            ),
          ),
        ),
        Divider(
          height: 0,
          color: Colors.green.shade200,
        ),
      ],
    );
  }

  final String appDesc = '''
تطبيق جمعية رواد للأعمال التطوعية
هنا شرح للتطبيق وأهداف الجمعية ورؤيتها والخطط المستقبلية هنا شرح للتطبيق وأهداف الجمعية ورؤيتها والخطط المستقبلية 
هنا شرح للتطبيق وأهداف الجمعية ورؤيتها والخطط المستقبلية 
هنا شرح للتطبيق وأهداف الجمعية ورؤيتها والخطط المستقبلية 
هنا شرح للتطبيق وأهداف الجمعية ورؤيتها والخطط المستقبلية 
''';
}
