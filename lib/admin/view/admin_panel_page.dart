import 'package:app/chances/view/add_chance_page.dart';
import 'package:app/courses/view/add_course_page.dart';
import 'package:app/news/view/add_news_page.dart';
import 'package:app/posters/view/add_poster_page.dart';
import 'package:app/teams/view/add_team_page.dart';
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
  final _addCategoryController = TextEditingController();
  final _isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.newspaper),
              title: const Text('إضافة خبر'),
              subtitle: const Text('إضافة خبر جديد للمركز الإعلامي'),
              trailing: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
              ),
              onTap: () => PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: AddNewsPage(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 4.h,
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.news_solid),
              title: const Text('إضافة فرصة'),
              subtitle: const Text('إضافة فرصة تطوعية جديدة'),
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
            ListTile(
              leading: const Icon(CupertinoIcons.rectangle),
              title: const Text('إضافة إعلان'),
              subtitle: const Text('إضافة إعلان فى أعلى الصفحة الرئيسية'),
              trailing: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
              ),
              onTap: () => PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: AddPosterPage(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 4.h,
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.collections),
              title: const Text('إضافة دورة تدريبية'),
              subtitle: const Text(''),
              trailing: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
              ),
              onTap: () => PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: AddCoursePage(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
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
              title: const Text('إضافة فريق تطوعي'),
              subtitle: const Text(''),
              trailing: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
              ),
              onTap: () => PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: AddTeamPage(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 4.h,
            ),
          ],
        ),
      ),
    );
  }
}
