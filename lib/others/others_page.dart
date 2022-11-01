import 'package:app/admin/view/admin_panel_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../courses/view/courses_page.dart';
import '../main.dart';
import '../utils/constants.dart';

class OthersPage extends StatelessWidget {
  const OthersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenColor,
        title: const Text('إختيارات أخرى'),
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
            leading: const Icon(Icons.class_),
            title: const Text('الدورات التدريبية'),
            subtitle: const Text('دورات معتمدة من خبراء متخصصين'),
            trailing: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 15,
            ),
            onTap: () => PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: const CoursesPage(),
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
            tileColor: Colors.amber.shade100,
            leading: const Icon(CupertinoIcons.person_fill),
            title: const Text('حسابي'),
            subtitle: const Text('معلومات عن حسابك وصلاحيته'),
            trailing: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 15,
            ),
            onTap: () => Fluttertoast.showToast(msg: 'تحت الإنشاء'),
          ),
          Divider(
            color: Colors.grey,
            height: 4.h,
          ),
          ListTile(
            tileColor: kGreenColor.withOpacity(0.5),
            leading: const Icon(Icons.update_sharp),
            title: const Text(
              'تطبيق رواد [تحت الإنشاء]',
            ),
            subtitle: const Text('نسخة $appVersion'),
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
        ],
      ),
    );
  }
}
