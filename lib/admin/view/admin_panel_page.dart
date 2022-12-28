import 'dart:ui';

import 'package:app/admin/view/users_page.dart';
import 'package:app/admin/view/widgets/team_leader_panel.dart';
import 'package:app/chances/view/add_chance_page.dart';
import 'package:app/courses/view/add_course_page.dart';
import 'package:app/news/view/add_news_page.dart';
import 'package:app/notifications/view/send_notification_page.dart';
import 'package:app/posters/view/add_poster_page.dart';
import 'package:app/profile/controller/profile_controller.dart';
import 'package:app/stats/stats_page.dart';
import 'package:app/teams/controller/team_controller.dart';
import 'package:app/teams/view/add_team_page.dart';
import 'package:app/utils/sharedprefs.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:app/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../utils/constants.dart';

class AdminPanelPage extends StatelessWidget {
  AdminPanelPage({Key? key}) : super(key: key);
  var teamController = Get.put(TeamController());
  final _addCategoryController = TextEditingController();
  final _isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    print('user Role: ${sharedPrefs.userRole}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenColor,
        title: const Text('لوحة التحكم'),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                getUserRoleInAROf(sharedPrefs.userRole),
                style: TextStyle(
                  fontSize: 24.sp,
                  color: kGreenColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5.h),
              if (sharedPrefs.userRole == kTeamLeader) TeamLeaderPanel(),
              if (sharedPrefs.userRole == kAdmin)
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.group,
                      ),
                      title: const Text('الأعضاء والصلاحيات'),
                      subtitle: const Text('تعيين وتعديل صلاحيات الأعضاء'),
                      trailing: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 15,
                      ),
                      onTap: () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: UsersPage(),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.h,
                    ),
                  ],
                ),
              ListTile(
                leading: const Icon(CupertinoIcons.news_solid),
                title: const Text('إضافة فرصة'),
                subtitle: const Text('اضافة فرصة تطوعية جديدة'),
                trailing: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 15,
                ),
                onTap: () => PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: AddChance(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 4.h,
              ),
              if (sharedPrefs.userRole == kAdmin ||
                  sharedPrefs.userRole == kEditor)
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.newspaper),
                      title: const Text('إضافة خبر'),
                      subtitle: const Text('اضافة خبر جديد للمركز الإعلامي'),
                      trailing: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 15,
                      ),
                      onTap: () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: AddNewsPage(),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.h,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.notifications,
                      ),
                      title: const Text('ارسال إشعار عام'),
                      subtitle: const Text('ارسال إشعار عام لجميع الأعضاء'),
                      trailing: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 15,
                      ),
                      onTap: () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: SendNotificationPage(),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.h,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.group,
                      ),
                      title: const Text('اضافة فريق تطوعي'),
                      subtitle: const Text(''),
                      trailing: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 15,
                      ),
                      onTap: () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: AddTeamPage(),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.h,
                    ),
                    ListTile(
                      leading: const Icon(CupertinoIcons.collections),
                      title: const Text('اضافة دورة تدريبية'),
                      subtitle: const Text(''),
                      trailing: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 15,
                      ),
                      onTap: () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: AddCoursePage(),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.h,
                    ),
                    ListTile(
                      leading: const Icon(Icons.bar_chart),
                      title: const Text('الإحصائيات'),
                      subtitle: const Text('تعديل الإحصائيات'),
                      trailing: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 15,
                      ),
                      onTap: () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: StatsPage(),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.h,
                    ),
                    ListTile(
                      leading: const Icon(CupertinoIcons.rectangle),
                      title: const Text('إضافة إعلان'),
                      subtitle:
                          const Text('اضافة إعلان فى أعلى الصفحة الرئيسية'),
                      trailing: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 15,
                      ),
                      onTap: () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: AddPosterPage(),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.h,
                    ),
                  ],
                ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: const Icon(CupertinoIcons.list_bullet),
                        title: const Text('تصنيقات عامة'),
                        subtitle: const Text('الفرص والفرق'),
                        trailing: sharedPrefs.userRole == kTeamLeader
                            ? const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 15,
                              )
                            : const SizedBox(),
                        onTap: () => showAddGeneralCategoryDialog(),
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.grey,
                    ),
                    if (sharedPrefs.userRole == kAdmin ||
                        sharedPrefs.userRole == kEditor)
                      Expanded(
                        child: ListTile(
                          leading: const Icon(CupertinoIcons.list_bullet),
                          title: const Text('تصنيفات الأخبار'),
                          subtitle: const Text(''),
                          onTap: () => showAddTeamCategoryDialog(),
                        ),
                      ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 4.h,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  void showAddGeneralCategoryDialog() {
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
                                      trailing: (sharedPrefs.userRole ==
                                                  kAdmin ||
                                              sharedPrefs.userRole == kEditor)
                                          ? IconButton(
                                              icon: const Icon(
                                                CupertinoIcons.xmark,
                                                size: 18,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        'general_categories')
                                                    .doc(result[index].id)
                                                    .delete();
                                                Fluttertoast.showToast(
                                                    msg: 'تم حذف التصنيف');
                                              },
                                            )
                                          : const SizedBox(),
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

  void showAddTeamCategoryDialog() {
    Get.defaultDialog(
      title: 'اضافة تصنيف',
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Expanded(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('news_categories')
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
                                      trailing: IconButton(
                                        icon: const Icon(
                                          CupertinoIcons.xmark,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('news_categories')
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
                      // result.forEach((element) {
                      //   print(element.data());
                      //   Map category = element.data() as Map;
                      //   categoriesList.add(category['name']);
                      // });
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
                                .collection('news_categories')
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
}
