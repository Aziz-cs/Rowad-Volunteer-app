import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'news_details_page.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: const NewsDetailsPage(),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        child: Container(
          width: 140.w,
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/news_0.jpeg',
                ),
                SizedBox(height: 1.h),
                Text(
                  'التبرع لمدارس إفريقيا',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'حملة التبرع لمدارس إفريقيا وشمال إفريقيا',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.calendar_today,
                      size: 20,
                      color: Colors.green,
                    ),
                    SizedBox(width: 5.w),
                    Flexible(
                      child: Text(
                        '22-9-2010',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
