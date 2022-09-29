import 'package:app/home/item_news.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'last_banners.dart';
import 'item_chance.dart';
import '../notifications/notification_page.dart';

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: const Color(0xFF48B777),
                  height: 0.16.sh,
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
                LastBanners(),
                _buildLastChancesSection(),
                SizedBox(height: 10.h),
                _buildLastNewsSection(),
              ],
            ),
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
                radius: 35,
                backgroundImage: Image.asset("assets/images/avatar.jpg").image,
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
                SizedBox(height: 3.h),
                Text(
                  'محمد عزيز',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.5.sp,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ),
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
        )
      ],
    );
  }

  Padding _buildLastChancesSection() {
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
              Row(
                children: [
                  Text(
                    'شاهد الكل',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      height: 1,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 13.h),
          SizedBox(
            height: 180.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                10,
                (index) => ChanceItem(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildLastNewsSection() {
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
              Row(
                children: [
                  Text(
                    'شاهد الكل',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      height: 1,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 13.h),
          SizedBox(
            height: 160.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                10,
                (index) => NewsItem(),
              ),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
