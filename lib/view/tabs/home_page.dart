import 'package:app/constants.dart';
import 'package:app/view/news_page.dart';
import 'package:app/view/notification_page.dart';
import 'package:app/view/tabs/opportunities_page.dart';
import 'package:app/view/widgets/opportunity_item.dart';
import 'package:app/view/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../widgets/simple_btn.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final _searchTextFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: const Color(0xFF48B777),
                  height: 0.23.sh,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    children: [
                      SizedBox(height: 50.h),
                      _buildProfileRow(context),
                      SizedBox(height: 13.h),
                      _buildSearchRow(),
                    ],
                  ),
                ),
                _buildNewsSection(context),
                _buildOpportunitiesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildOpportunitiesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'آخر الفرص التطوعية',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text(
                    'شاهد الكل',
                    style: TextStyle(fontSize: 13.5.sp, height: 1),
                  ),
                  SizedBox(width: 3.w),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 13.h),
          GridView.count(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: List.generate(
              4,
              (index) => OpportunityItem(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsSection(BuildContext context) {
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
            // controller: pageController,
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

  Row _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: MyTextField(
            label: 'عن ماذا نبحث ...',
            controller: _searchTextFieldController,
            validator: (_) {},
            preIcon: const Icon(
              CupertinoIcons.search,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: 7.w),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.manage_search_rounded,
              size: 30,
            ),
          ),
        )
      ],
    );
  }

  Row _buildProfileRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.2,
                ),
              ),
              child: CircleAvatar(
                radius: 35,
                backgroundImage: Image.asset("assets/images/avatar.jpg").image,
              ),
            ),
            SizedBox(width: 9.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحبا',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'محمد عزيز',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.5.sp,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ),
        IconButton(
          onPressed: () {
            pushNewScreen(
              context,
              screen: const NotificationPage(),
              withNavBar: true, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          icon: const Icon(
            CupertinoIcons.bell,
            size: 26,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
