import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../news/view/news_details_page.dart';
import '../../utils/constants.dart';
import '../../widgets/simple_btn.dart';

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

class LastBanners extends StatelessWidget {
  LastBanners({Key? key}) : super(key: key);

  final _lastNewsController = PageController(initialPage: 0, keepPage: false);
  int bannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Banner clicked'),
      child: Container(
        height: 200.h,
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
          child: PageView(
            onPageChanged: (bannerIndexAfterChange) {
              print('bannerIndexAfterChange $bannerIndexAfterChange');
              bannerIndex = bannerIndexAfterChange;
            },
            controller: _lastNewsController,
            allowImplicitScrolling: true,
            children: List.generate(
              4,
              (index) => ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/news_$index.jpeg',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      height: 200.h,
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
                              0.5,
                            ],
                          )),
                    ),
                    Positioned(
                      top: 77.h,
                      left: 5.w,
                      child: IconButton(
                        onPressed: () {
                          print('bannerIndex: $bannerIndex');
                          if (bannerIndex < 3) {
                            bannerIndex++;
                            _lastNewsController.animateToPage(bannerIndex,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          } else {
                            _lastNewsController.animateToPage(bannerIndex + 1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_circle_left_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 77.h,
                      right: 5.w,
                      child: IconButton(
                        onPressed: () {
                          print('bannerIndex: $bannerIndex');
                          // if (bannerIndex < 1) {
                          if (bannerIndex > 0) {
                            bannerIndex--;
                            _lastNewsController.animateToPage(bannerIndex,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          } else {
                            _lastNewsController.animateToPage(bannerIndex - 1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          }

                          // }
                        },
                        icon: const Icon(
                          Icons.arrow_circle_right_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 19.h,
                      right: 4.w,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'التبرع لمدارس إفريقيا',
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                SizedBox(
                                  width: 220.w,
                                  child: Text(
                                    'حملة التبرع لمدارس إفريقيا وشمال إفريقيا برعاية جمعية وراد التطوعي',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      height: 1,
                                      fontSize: 13.3.sp,
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
                      bottom: 16.h,
                      left: 10.w,
                      child: SimpleButton(
                          label: 'إقرأ المزيد',
                          onPress: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const NewsDetailsPage(),
                              withNavBar:
                                  true, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
