import 'package:app/posters/view/edit_poster_page.dart';
import 'package:app/profile/controller/profile_controller.dart';
import 'package:app/utils/helper.dart';
import 'package:app/utils/sharedprefs.dart';
import 'package:app/widgets/online_img.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../../widgets/circular_loading.dart';
import '../../../widgets/simple_btn.dart';
import '../../model/poster.dart';

const Color background = kGreenColor;
const Color fill = Color(0xFFF3F3F3);
final List<Color> gradient = [
  background,
  background,
  fill,
  fill,
];
const double fillPercent = 35; // fills 56.23% for container from bottom
const double fillStop = (100 - fillPercent) / 100;
final List<double> stops = [0.0, fillStop, fillStop, 1.0];

class SlideBanners extends StatelessWidget {
  SlideBanners({Key? key}) : super(key: key);
  CarouselController buttonCarouselController = CarouselController();

  int bannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Banner clicked'),
      child: Container(
        height: 160.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            stops: stops,
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
          ),
        ),
        padding: EdgeInsets.only(bottom: 12.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posters')
                .orderBy('timestamp')
                .limitToLast(5)
                .snapshots(),
            builder: ((context, snapshot) {
              List<Poster> posterItems = [];

              if (snapshot.connectionState == ConnectionState.active) {
                print(snapshot.connectionState.toString());
                var posterData = snapshot.data!.docs;

                posterData.forEach(
                  (chanceElement) {
                    Poster aPoster = Poster.fromDB(
                      chanceElement.data() as Map<String, dynamic>,
                      chanceElement.id,
                    );
                    posterItems.add(aPoster);
                  },
                );
                return CarouselSlider(
                  items: List.generate(
                    posterItems.length,
                    (index) => ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Positioned.fill(
                              child: CachedOnlineIMG(
                                  imageURL: posterItems[index].imageURL)),
                          Container(
                            height: 200.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                  begin: FractionalOffset.centerLeft,
                                  end: FractionalOffset.centerRight,
                                  colors: [
                                    Colors.grey.withOpacity(0.0),
                                    Colors.black.withOpacity(0.45),
                                  ],
                                  stops: const [
                                    0.0,
                                    0.5,
                                  ],
                                )),
                          ),
                          Positioned(
                            top: 2.h,
                            left: 7.w,
                            child: Text(
                              getFormatedDate(posterItems[index].timestamp),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.black26,
                              ),
                            ),
                          ),
                          if (sharedPrefs.userRole == kAdmin ||
                              sharedPrefs.userRole == kEditor)
                            Positioned(
                              right: 3,
                              child: IconButton(
                                icon: const Icon(
                                  CupertinoIcons.pencil_circle_fill,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Get.to(() => EditPosterPage(
                                      poster: posterItems[index]));
                                },
                              ),
                            ),
                          Positioned(
                            top: 55.h,
                            left: 1.w,
                            child: IconButton(
                              onPressed: () {
                                buttonCarouselController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.linear);
                              },
                              icon: const Icon(
                                Icons.arrow_circle_left_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 55.h,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                buttonCarouselController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.linear);
                              },
                              icon: const Icon(
                                Icons.arrow_circle_right_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10.h,
                            right: 4.w,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 220.w,
                                        child: Text(
                                          posterItems[index].title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            height: 1,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5.h,
                            left: 8.w,
                            child: SimpleButton(
                              label: '???????? ????????????',
                              onPress: () =>
                                  Helper.openURL('https://nvg.gov.sa/'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  carouselController: buttonCarouselController,
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                    aspectRatio: 2.5,
                    initialPage: 2,
                  ),
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
      ),
    );
  }
}
