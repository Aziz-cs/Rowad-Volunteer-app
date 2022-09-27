import 'package:app/view/news_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../constants.dart';
import '../widgets/simple_btn.dart';

const Color background = kGreenColor;
const Color fill = Colors.white;
final List<Color> gradient = [
  background,
  background,
  fill,
  fill,
];
const double fillPercent = 35; // fills 56.23% for container from bottom
const double fillStop = (100 - fillPercent) / 100;
final List<double> stops = [0.0, fillStop, fillStop, 1.0];

class LastNews extends StatefulWidget {
  const LastNews({Key? key}) : super(key: key);

  @override
  State<LastNews> createState() => _LastNewsState();
}

class _LastNewsState extends State<LastNews> {
  final _lastNewsController = PageController(initialPage: 0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => const NewsPage()),
      child: Container(
        height: 200.h,
        // color: const Color(0xFF48B777),
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
            onPageChanged: (currentPage) {},
            controller: _lastNewsController,
            allowImplicitScrolling: true,
            children: List.generate(
              2,
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
                      left: 0,
                      child: IconButton(
                        onPressed: () => print('go to next news'),
                        icon: const Icon(
                          Icons.arrow_circle_left_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 77.h,
                      right: 0,
                      child: IconButton(
                        onPressed: () => print('go to previous news'),
                        icon: const Icon(
                          Icons.arrow_circle_right_rounded,
                          color: Colors.white,
                          size: 30,
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
                            pushNewScreen(
                              context,
                              screen: const NewsPage(),
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
