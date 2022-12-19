import 'package:app/admin/view/admin_panel_page.dart';
import 'package:app/profile/view/profile_page.dart';
import 'package:app/teams/view/teams_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../courses/view/courses_page.dart';
import '../main.dart';
import '../utils/constants.dart';
import '../widgets/menu_drawer.dart';

class OthersPage extends StatelessWidget {
  OthersPage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuDrawer(),
      appBar: AppBar(
        backgroundColor: kGreenColor,
        title: Text(
          'اختيارات أخرى',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            }),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          ListTile(
            leading: const Icon(CupertinoIcons.person_fill),
            title: const Text('حسابي'),
            subtitle: const Text('معلومات عن حسابك وصلاحيته'),
            trailing: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 15,
            ),
            onTap: () => PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: ProfilePage(),
              withNavBar: true, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 4.h,
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('الفرق التطوعية'),
            subtitle: const Text('دورات معتمدة من خبراء متخصصين'),
            trailing: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 15,
            ),
            onTap: () => PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: TeamsPage(),
              withNavBar: true, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 4.h,
          ),
          ListTile(
            leading: const Icon(Icons.class_),
            title: const Text('الدورات التدريبية'),
            subtitle: const Text('دورات معتمدة من خبراء متخصصين'),
            trailing: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 15,
            ),
            onTap: () => PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: CoursesPage(),
              withNavBar: true, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 4.h,
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('لوحة التحكم'),
            subtitle: const Text('إعدادات المدير العام'),
            trailing: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 15,
            ),
            onTap: () => PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: AdminPanelPage(),
              withNavBar: true, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 4.h,
          ),
          ListTile(
            tileColor: kGreenColor.withOpacity(0.5),
            leading: const Icon(Icons.update_sharp),
            title: const Text(
              'تطبيق رواد',
            ),
            subtitle: const Text('نسخة $appVersion'),
            onTap: () {},
          ),
          Divider(
            color: Colors.grey,
            height: 4.h,
          ),
        ],
      ),
    );
  }
}
