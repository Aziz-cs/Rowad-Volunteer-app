import 'package:app/news/model/news.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/helper.dart';
import 'package:app/widgets/online_img.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../news_details_page.dart';

class NewsItemHP extends StatelessWidget {
  NewsItemHP({
    Key? key,
    required this.news,
  }) : super(key: key);

  News news;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: NewsDetailsPage(news: news),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      ),
      child: Container(
        width: 190.w,
        padding: const EdgeInsets.all(4),
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedOnlineIMG(
                imageURL: news.imageURL,
                imageHeight: 120,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Text(
                      news.category,
                      maxLines: 1,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 13.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      news.subTitle,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(
                            CupertinoIcons.calendar_today,
                            size: 17,
                            color: Colors.green,
                          ),
                          SizedBox(width: 2.w),
                          Flexible(
                            child: Text(
                              getFormatedDate(news.timestamp),
                              style: TextStyle(
                                fontSize: 13.sp,
                                height: 1,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
