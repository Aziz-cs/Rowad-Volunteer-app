import 'package:app/constants.dart';
import 'package:app/view/tabs/home_page.dart';
import 'package:app/view/news_page.dart';
import 'package:app/view/tabs/other_page.dart';
import 'package:app/view/tabs/profile_page.dart';
import 'package:app/view/tabs/opportunities_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NavigatorPage extends StatelessWidget {
  NavigatorPage({Key? key}) : super(key: key);
  late PersistentTabController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = PersistentTabController(initialIndex: 0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: kGreenColor, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
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
        navBarStyle:
            NavBarStyle.style3, // Choose the nav bar style with this property.
      ),
    );
  }
}

List<Widget> _buildScreens() {
  return [
    HomePage(),
    OpportunitiesPage(),
    ProfilePage(),
    OtherPage(),
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
      icon: const Icon(CupertinoIcons.person_fill),
      title: ("حسابي"),
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