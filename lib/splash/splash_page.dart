import 'package:app/widgets/navigator_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const kTopDownGrad = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Colors.green,
    Colors.green,
    Color(0xFFFFFFFF),
    Color(0xFFFFFFFF),
    Color(0xFFFFFFFF),
  ],
);

const String title = 'جمعية رواد التطوعية';
const String subtitle =
    'هي جمعية غير ربحية معنية بالعمل التطوعي وهدفها الربط بين المتطوعين والجهات التطوعية التى لديها مشاريع وترغب فى متطوعين';

class SplashPage extends StatelessWidget {
  SplashPage({Key? key}) : super(key: key);

  final currentPage = 0.obs;
  final _pageViewController = PageController(initialPage: 0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    print('current page: $currentPage');
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Obx(
          () => PageView(
            controller: _pageViewController,
            onPageChanged: ((currentPageView) {
              print('current page changed: $currentPageView');

              currentPage.value = currentPageView;
            }),
            children: [
              _buildSplashScreen(
                splashIndex: 0,
                currentPage: currentPage.value,
                title: title,
                subtitle: subtitle,
              ),
              _buildSplashScreen(
                splashIndex: 1,
                currentPage: currentPage.value,
                title: title,
                subtitle: subtitle,
              ),
              _buildSplashScreen(
                splashIndex: 2,
                currentPage: currentPage.value,
                title: title,
                subtitle: subtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack _buildSplashScreen({
    required int splashIndex,
    required int currentPage,
    required String title,
    required String subtitle,
  }) {
    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              'assets/images/splash$splashIndex.png',
            ),
          ),
        ),
      ),
      Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.green,
                ],
                stops: [
                  0.0,
                  1.0
                ])),
      ),
      Positioned(
        top: 40.h,
        right: 3.w,
        child: Image.asset('assets/images/logo.png'),
      ),
      Positioned(
        right: 20.w,
        bottom: 0.3.sh,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 25.sp,
            color: Colors.white,
          ),
        ),
      ),
      Positioned(
        right: 20.w,
        bottom: 0.2.sh,
        child: SizedBox(
          width: 0.93.sw,
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 17.sp,
            ),
          ),
        ),
      ),
      Positioned(
        left: 20.w,
        bottom: 57.h,
        child: GestureDetector(
          onTap: () {
            print('pressed $currentPage');
            if (currentPage < 2) {
              _pageViewController.animateToPage(currentPage + 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            } else {
              Get.offAll(() => NavigatorPage());
            }
          },
          child: Row(
            children: [
              Text(
                currentPage == 2 ? 'البدء' : 'التالي',
                style: TextStyle(
                  fontSize: 15.sp,
                  height: 0.8,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 4.w),
              const Icon(
                CupertinoIcons.arrow_left,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      Positioned(
        right: 30.w,
        bottom: 63.h,
        child: Row(
          children: [
            _buildDot(isSelected: currentPage == 0),
            _buildDot(isSelected: currentPage == 1),
            _buildDot(isSelected: currentPage == 2),
          ],
        ),
      ),
      Positioned(
        top: 80.h,
        left: 2.h,
        child: GestureDetector(
          onTap: () => Get.offAll(() => NavigatorPage()),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'تخطي',
              style: TextStyle(
                fontSize: 17.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      )
    ]);
  }

  Widget _buildDot({
    required bool isSelected,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Row(
        children: [
          Container(
            width: 19.w,
            height: 5.h,
            decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white54,
                borderRadius: BorderRadius.circular(10)),
          ),
        ],
      ),
    );
  }
}
