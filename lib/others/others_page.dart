import 'package:app/admin/add_chance_page.dart';
import 'package:app/admin/add_news_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
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
            leading: const Icon(CupertinoIcons.person_fill),
            title: const Text('حسابي'),
            subtitle: const Text('معلومات عن حسابك وصلاحيته'),
            trailing: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 15,
            ),
            onTap: () => print('Account clicked'),
          ),
          Divider(
            color: Colors.grey,
            height: 4.h,
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text('إضافة خبر'),
            subtitle: const Text('معلومات عن حسابك وصلاحيته'),
            trailing: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 15,
            ),
            onTap: () => PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: AddNews(),
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
            subtitle: const Text('معلومات عن حسابك وصلاحيته'),
            trailing: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 15,
            ),
            onTap: () => PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: const AddChance(),
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
