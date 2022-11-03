import 'package:app/courses/view/courses_page.dart';
import 'package:app/courses/view/widgets/item_course_hp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../chances/model/chance.dart';
import '../../chances/view/widgets/item_chance.dart';
import '../../courses/model/course.dart';
import '../../news/model/news.dart';
import '../../news/view/widgets/item_news.dart';
import '../../notifications/notification_page.dart';
import '../../posters/view/widgets/slider_banners.dart';
import '../../widgets/circular_loading.dart';
import '../../widgets/navigator_page.dart';

enum Category { news, chances, courses, programs }

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
                    Image.asset("assets/images/welcome_avatar.png").image,
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
        Stack(
          children: [
            IconButton(
              onPressed: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: const NotificationPage(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
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
            height: 265.h,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chances')
                  .orderBy('timestamp', descending: false)
                  .limitToLast(10)
                  .snapshots(),
              builder: ((context, snapshot) {
                List<ChanceItem> chanceItems = [];

                if (snapshot.connectionState == ConnectionState.active) {
                  print(snapshot.connectionState.toString());
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
                  children: const [
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
                screen: const CoursesPage(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
              break;
            case Category.programs:
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
          SizedBox(
            height: 200.h,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('news')
                  .orderBy('timestamp', descending: false)
                  .limitToLast(10)
                  .snapshots(),
              builder: ((context, snapshot) {
                List<NewsItem> newsItems = [];

                if (snapshot.connectionState == ConnectionState.active) {
                  print(snapshot.connectionState.toString());
                  var newsResult = snapshot.data!.docs;

                  newsResult.forEach(
                    (newsElement) {
                      News news = News.fromDB(
                        newsElement.data() as Map<String, dynamic>,
                        newsElement.id,
                      );
                      newsItems.add(NewsItem(news: news));
                    },
                  );
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: newsItems.reversed.toList(),
                  );
                }
                return Column(
                  children: const [
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
                  print(snapshot.connectionState.toString());
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
                  children: const [
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
