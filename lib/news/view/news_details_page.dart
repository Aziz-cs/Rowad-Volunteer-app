import 'package:app/news/view/edit_news_page.dart';
import 'package:app/profile/controller/profile_controller.dart';
import 'package:app/utils/sharedprefs.dart';
import 'package:app/widgets/online_img.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../../utils/helper.dart';
import '../../widgets/back_btn.dart';
import '../model/news.dart';

const String opportunityDetails = 'هذا النص الذي يعطي نبذة عن الفرصة التطوعية ';

class NewsDetailsPage extends StatelessWidget {
  NewsDetailsPage({
    Key? key,
    required this.news,
  }) : super(key: key);
  News news;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: SafeArea(
          child: Column(
            children: [
              _buildNewsHeadbar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          news.description,
                          style: TextStyle(
                            fontSize: 15.5.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      if (news.gallery.isNotEmpty)
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            initialPage: 1,
                            enlargeCenterPage: true,
                            autoPlayInterval: const Duration(seconds: 3),
                          ),
                          items: news.gallery
                              .map((imageURL) => InkWell(
                                  onTap: () => Get.defaultDialog(
                                      title: news.title,
                                      content: CachedNetworkImage(
                                        imageUrl: imageURL,
                                      )),
                                  child: CachedOnlineIMG(imageURL: imageURL)))
                              .toList(),
                        ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack _buildNewsHeadbar(BuildContext context) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: news.imageURL,
          fit: BoxFit.fill,
          height: 210.h,
          width: double.infinity,
          placeholder: (context, url) => Padding(
            padding: const EdgeInsets.all(30.0),
            child: Image.asset('assets/images/loading_spinner.gif'),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.error,
            color: kGreenColor,
          ),
        ),
        Container(
          height: 210.h,
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: FractionalOffset.centerLeft,
                end: FractionalOffset.centerRight,
                colors: [
                  Colors.grey.withOpacity(0.0),
                  Colors.black.withOpacity(0.65)
                ],
                stops: const [
                  0.0,
                  0.7,
                ],
              )),
        ),
        if (sharedPrefs.userRole == kAdmin || sharedPrefs.userRole == kEditor)
          Positioned(
              top: 4.h,
              left: 4.w,
              child: IconButton(
                onPressed: () {
                  Get.to(() => EditNewsPage(news: news));
                },
                icon: const Icon(
                  CupertinoIcons.pencil_circle_fill,
                  color: Colors.amber,
                  size: 30,
                ),
              )),
        Positioned(
          bottom: 2.h,
          right: 2.w,
          child: Text(
            getFormatedDate(news.timestamp),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          right: 5.w,
          child: BackBtn(),
        ),
        Positioned(
          bottom: 30.h,
          right: 5.w,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              width: 0.85.sw,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    maxLines: 2,
                    style: TextStyle(
                      height: 1,
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
