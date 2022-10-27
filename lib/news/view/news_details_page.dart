import 'package:app/news/view/edit_news_page.dart';
import 'package:app/widgets/online_img.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
        backgroundColor: const Color(0xFFF3F3F3),
        appBar: AppBar(toolbarHeight: 0),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNewsHeadbar(context),
              SizedBox(height: 10.h),
              _buildNewsDetails(),
              if (news.gallery.isNotEmpty) SizedBox(height: 190.h),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.1,
                initialPage: 1,
                enlargeCenterPage: true,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: news.gallery
                  .map((imageURL) => CachedOnlineIMG(imageURL: imageURL))
                  .toList(),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsDetails() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: Column(
            children: [
              Text(
                news.description,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 20.h),
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
                  Colors.black.withOpacity(0.65),
                ],
                stops: const [
                  0.0,
                  0.7,
                ],
              )),
        ),
        Positioned(
            top: 4.h,
            left: 4.w,
            child: IconButton(
              onPressed: () {
                Get.to(() => EditNewsPage(news: news));
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            )),
        Positioned(
          bottom: 2.h,
          left: 2.w,
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
          child: const BackBtn(),
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
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    news.subTitle,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      height: 1,
                      fontSize: 13.sp,
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
