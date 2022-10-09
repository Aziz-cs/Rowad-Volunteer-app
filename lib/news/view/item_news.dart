import 'package:app/news/model/news.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'news_details_page.dart';

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
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        child: Container(
          width: 140.w,
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: news.imageURL,
                fit: BoxFit.fill,
                height: 110.h,
                width: double.infinity,
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Image.asset('assets/images/loading_spinner.gif'),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error_outline,
                  color: kGreenColor,
                  size: 40,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                news.title,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                news.subTitle,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
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
                      news.getFormatedDate(),
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
    );
  }
}
