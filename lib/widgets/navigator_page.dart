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
    _controller = PersistentTabController(initialIndex: tabIndex);

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
    const ChancesPage(),
    const NewsPage(),
    const OthersPage(),
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