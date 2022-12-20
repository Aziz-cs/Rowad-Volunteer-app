import 'dart:io';

import 'package:app/profile/view/complete_profile.dart';
import 'package:app/start/splash_page.dart';
import 'package:app/utils/sharedprefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../chances/view/chances_page.dart';
import '../others/others_page.dart';
import '../utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../home/view/home_page.dart';
import '../news/view/news_page.dart';

class NavigatorPage extends StatelessWidget {
  NavigatorPage({
    Key? key,
    this.tabIndex = 0,
  }) : super(key: key);
  late PersistentTabController _controller;
  int tabIndex;
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission();
    }
    FirebaseMessaging.instance.subscribeToTopic('global');
    _controller = PersistentTabController(
      initialIndex: tabIndex,
    );
    print('uid == ${FirebaseAuth.instance.currentUser?.uid}');
    print('email: ${FirebaseAuth.instance.currentUser?.email}');
    bool isGuest = FirebaseAuth.instance.currentUser?.uid != null &&
        FirebaseAuth.instance.currentUser?.email == null;
    print('isGuest: $isGuest');
    return isGuest || sharedPrefs.isCompletedProfile
        ? showHomePage(context)
        : FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // print(snapshot.data);
                if (snapshot.data!.data() != null) {
                  print('snapshot.data != null');
                  return showHomePage(context);
                } else {
                  print('snapshot.data == null');
                  if (FirebaseAuth.instance.currentUser?.email != null) {
                    return CompleteProfile();
                  } else {
                    return showHomePage(context);
                  }
                }
              }
              return showHomePage(context);
            }),
          );
  }

  Directionality showHomePage(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),

        confineInSafeArea: true,
        popAllScreensOnTapAnyTabs: true,
        backgroundColor: kGreenColor, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            false, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: const NavBarDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          adjustScreenBottomPaddingOnCurve: true,
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style3,
        // Choose the nav bar style with this property.
      ),
    );
  }
}

List<Widget> _buildScreens() {
  return [
    HomePage(),
    ChancesPage(),
    NewsPage(),
    OthersPage(),
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.home),
      title: ("الرئيسية"),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.white54,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.news_solid),
      title: ("الفرص"),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.white54,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.newspaper),
      title: ("المركز الإعلامي"),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.white54,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.circle_grid_3x3_fill),
      title: ("أخرى"),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.white54,
    ),
  ];
}
