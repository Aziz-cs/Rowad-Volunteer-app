import 'package:app/news/model/news.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/helper.dart';
import 'package:app/widgets/online_img.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../news_details_page.dart';

class NewsItem extends StatelessWidget {
  NewsItem({
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
        width: 160.w,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: CachedOnlineIMG(imageURL: news.imageURL),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.h),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: kGreenColor,
                    ),
                    child: Text(
                      news.title,
                      maxLines: 1,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 13.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news.subTitle,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey.shade600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.calendar_today,
                                      size: 17,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 5.w),
                                    Flexible(
                                      child: Text(
                                        getFormatedDate(news.timestamp),
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
