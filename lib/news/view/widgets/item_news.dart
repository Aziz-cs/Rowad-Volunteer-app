import 'package:app/news/model/news.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/helper.dart';
import 'package:app/widgets/online_img.dart';
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
    return Column(
      children: [
        ListTile(
          onTap: () => PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: NewsDetailsPage(news: news),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox(
              width: 55.w,
              height: 55.h,
              child: CachedOnlineIMG(imageURL: news.imageURL),
            ),
          ),
          title: Text(
            news.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            news.subTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(),
              const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 13,
                color: kGreenColor,
              ),
              Text(
                getFormatedDate(news.timestamp),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}
