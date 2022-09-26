import 'package:app/view/navigator_page.dart';
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

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int currentPage = 1;
  final _pageViewController = PageController(initialPage: 0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: PageView(
          controller: _pageViewController,
          onPageChanged: ((currentPageView) {
            setState(() {
              currentPage = currentPageView + 1;
            });
          }),
          children: [
            _buildSplashScreen(
              splashIndex: 1,
              currentPage: currentPage,
              title: title,
              subtitle: subtitle,
            ),
            _buildSplashScreen(
              splashIndex: 2,
              currentPage: currentPage,
              title: title,
              subtitle: subtitle,
            ),
            _buildSplashScreen(
              splashIndex: 3,
              currentPage: currentPage,
              title: title,
              subtitle: subtitle,
            ),
          ],
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
            if (currentPage < 3) {
              _pageViewController.animateToPage(currentPage,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            } else {
              Get.offAll(() => NavigatorPage());
            }
          },
          child: Row(
            children: [
              Text(
                currentPage == 3 ? 'البدء' : 'التالي',
                style: TextStyle(
                  fontSize: 15.sp,
                  height: 0.8,
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
            _buildDot(isSelected: currentPage == 1),
            _buildDot(isSelected: currentPage == 2),
            _buildDot(isSelected: currentPage == 3),
          ],
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
