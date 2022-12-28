import 'package:app/chances/controller/chances_controller.dart';
import 'package:app/courses/view/courses_page.dart';
import 'package:app/courses/view/widgets/item_course_hp.dart';
import 'package:app/notifications/view/global_notification_page.dart';
import 'package:app/profile/model/volunteer.dart';
import 'package:app/stats/stats_page.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/circle_logo.dart';
import 'package:app/widgets/menu_drawer.dart';
import 'package:app/widgets/online_img.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../chances/model/chance.dart';
import '../../chances/view/widgets/item_chance.dart';
import '../../courses/model/course.dart';
import '../../news/model/news.dart';
import '../../news/view/widgets/filter_bar.dart';
import '../../news/view/widgets/item_news_hp.dart';
import '../../posters/view/widgets/slider_banners.dart';
import '../../widgets/circular_loading.dart';
import '../../widgets/navigator_page.dart';

enum Category { news, chances, courses, stats }

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var selectedNewsCategory = kAllNewsCategory.obs;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const MenuDrawer(),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                color: const Color(0xFF48B777),
                height: 0.13.sh,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    SizedBox(height: 50.h),
                    _buildProfileRow(context),
                    // SizedBox(height: 13.h),
                    // _buildSearchRow(),
                  ],
                ),
              ),
              SlideBanners(),
              // LastBanners(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildLastNewsSection(context),
                      SizedBox(height: 12.h),
                      _buildLastChancesSection(context),
                      SizedBox(height: 12.h),
                      _buildLastCoursesSection(context),
                      SizedBox(height: 12.h),
                      _buildStatsSection(context),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildProfileRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            }),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FirebaseAuth.instance.currentUser?.email != null
                  ? const UserAvatarAndName()
                  : const GuestAvatarAndName(),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: NotificationPage(),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    icon: const Icon(
                      CupertinoIcons.bell,
                      size: 26,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 7.w,
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 3.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding _buildLastChancesSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'آخر الفرص التطوعية',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              _buildSeeAllBtn(
                context: context,
                categoryToRoute: Category.chances,
              )
            ],
          ),
          SizedBox(
            height: 275.h,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chances')
                  .orderBy('timestamp', descending: false)
                  .limitToLast(10)
                  .snapshots(),
              builder: ((context, snapshot) {
                List<ChanceItem> chanceItems = [];

                if (snapshot.connectionState == ConnectionState.active) {
                  var chanceData = snapshot.data!.docs;

                  chanceData.forEach(
                    (chanceElement) {
                      Chance aChance = Chance.fromDB(
                        chanceElement.data() as Map<String, dynamic>,
                        chanceElement.id,
                      );
                      chanceItems.add(ChanceItem(chance: aChance));
                    },
                  );
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: chanceItems.reversed.toList(),
                  );
                }
                return Column(
                  children: [
                    Center(child: CircularLoading()),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Directionality _buildSeeAllBtn({
    required BuildContext context,
    required Category categoryToRoute,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextButton.icon(
        onPressed: () {
          switch (categoryToRoute) {
            case Category.news:
              Get.offAll(
                () => NavigatorPage(tabIndex: 2),
                duration: const Duration(microseconds: 1),
              );
              break;
            case Category.chances:
              Get.offAll(
                () => NavigatorPage(tabIndex: 1),
                duration: const Duration(microseconds: 1),
              );
              break;
            case Category.courses:
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: CoursesPage(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
              break;
            case Category.stats:
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: StatsPage(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
              break;
            default:
          }
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 14,
          color: Colors.grey,
        ),
        label: Text(
          'شاهد الكل',
          style: TextStyle(
            fontSize: 13.5.sp,
            height: 1,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  Padding _buildLastNewsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'آخر الأخبار',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              _buildSeeAllBtn(
                context: context,
                categoryToRoute: Category.news,
              )
            ],
          ),
          NewsFilterBar(selectedNewsCategory: selectedNewsCategory),
          SizedBox(height: 3.h),
          SizedBox(
            height: 300.h,
            child: Obx(() => StreamBuilder<QuerySnapshot>(
                  stream: selectedNewsCategory.value == kAllNewsCategory
                      ? FirebaseFirestore.instance
                          .collection('news')
                          .orderBy('timestamp', descending: false)
                          .limitToLast(10)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('news')
                          .where('category',
                              isEqualTo: selectedNewsCategory.value)
                          .snapshots(),
                  builder: ((context, snapshot) {
                    List<NewsItemHP> newsItems = [];

                    if (snapshot.connectionState == ConnectionState.active) {
                      var newsResult = snapshot.data!.docs;

                      newsResult.forEach(
                        (newsElement) {
                          News news = News.fromDB(
                            newsElement.data() as Map<String, dynamic>,
                            newsElement.id,
                          );
                          newsItems.add(NewsItemHP(news: news));
                        },
                      );
                      if (selectedNewsCategory.isNotEmpty) {
                        newsItems.sort((a, b) =>
                            a.news.timestamp.compareTo(b.news.timestamp));
                      }

                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: newsItems.reversed.toList(),
                      );
                    }
                    return Column(
                      children: [
                        Center(child: CircularLoading()),
                      ],
                    );
                  }),
                )),
          ),
        ],
      ),
    );
  }

  Padding _buildStatsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أبرز الأحصائيات',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              _buildSeeAllBtn(
                context: context,
                categoryToRoute: Category.stats,
              )
            ],
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('stats')
                  .doc('stats')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  var result = snapshot.data!.data();
                  var resultMap = result as Map<String, dynamic>;
                  return SizedBox(
                    height: 130.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: kGreenColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // const RowadCircleLogo(radius: 20),
                                const Icon(
                                  Icons.group,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                Text(
                                  resultMap['volunteerNo'].toString(),
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'عدد المتطوعين',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                            child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(
                                      Icons.class_,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'عدد الدورات',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.white,
                                        height: 1,
                                      ),
                                    ),
                                    Text(
                                      resultMap['coursesNo'].toString(),
                                      style: TextStyle(
                                        fontSize: 26.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0391DF),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(
                                      Icons.bar_chart,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                    Flexible(
                                      child: Text(
                                        'عدد الفرص\n التطوعية',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      resultMap['chancesNo'].toString(),
                                      style: TextStyle(
                                        fontSize: 26.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  );
                }
                return CircularLoading();
              }),
        ],
      ),
    );
  }

  Padding _buildLastCoursesSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'آخر الدورات',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              _buildSeeAllBtn(
                context: context,
                categoryToRoute: Category.courses,
              )
            ],
          ),
          SizedBox(
            height: 265.h,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('courses')
                  .orderBy('timestamp', descending: false)
                  .limitToLast(10)
                  .snapshots(),
              builder: ((context, snapshot) {
                List<CourseItemHP> courseItems = [];

                if (snapshot.connectionState == ConnectionState.active) {
                  var coursesResult = snapshot.data!.docs;

                  coursesResult.forEach(
                    (courseElement) {
                      Course course = Course.fromDB(
                        courseElement.data() as Map<String, dynamic>,
                        courseElement.id,
                      );
                      courseItems.add(CourseItemHP(course: course));
                    },
                  );
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: courseItems.reversed.toList(),
                  );
                }
                return Column(
                  children: [
                    Center(child: CircularLoading()),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class GuestAvatarAndName extends StatelessWidget {
  const GuestAvatarAndName({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const RowadCircleLogo(radius: 24.5),
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
    );
  }
}

class UserAvatarAndName extends StatelessWidget {
  const UserAvatarAndName({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var result = snapshot.data!.data();
          Map<String, dynamic> resultMap = result as Map<String, dynamic>;
          Volunteer volunteer = Volunteer.fromDB(resultMap, snapshot.data!.id);
          print(volunteer.name);
          return Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.2,
                  ),
                ),
                child: ClipOval(
                  child: CachedOnlineIMG(
                    imageURL: volunteer.avatarURL.isEmpty
                        ? 'https://firebasestorage.googleapis.com/v0/b/rowad-774e0.appspot.com/o/avatar.png?alt=media&token=143096fd-3145-4a5f-a148-ae673d366b1e'
                        : volunteer.avatarURL,
                    imageWidth: 45,
                    imageHeight: 45,
                  ),
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
                    volunteer.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          );
        }
        return CircularLoading();
      }),
    );
  }
}
