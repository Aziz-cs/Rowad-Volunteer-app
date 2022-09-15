import 'package:app/view/widgets/simple_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const String opportunityDetails = 'هذا النص الذي يعطي نبذة عن الفرصة التطوعية ';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
        body: SafeArea(
          child: Column(
            children: [
              _buildOpportunityHeadbar(),
              SizedBox(height: 10.h),
              _buildOppertunityDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOppertunityDetails() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'التبرع لمدارس إفريقيا',
                style: TextStyle(
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                'التبرع لمدارس إفريقيا',
                style: TextStyle(
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails +
                          opportunityDetails,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack _buildOpportunityHeadbar() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                'assets/images/news_0.jpeg',
              ),
            ),
          ),
          height: 210.h,
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
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 13,
                  ),
                  Text(
                    'رجوع',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      height: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16.h,
          right: 15.w,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التطوع لمدارس إفريقيا',
                      style: TextStyle(
                        color: Colors.white,
                        height: 1,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 0.9.sw,
                      child: Text(
                        'حملة التبرع لمدارس إفريقيا وشمال إفريقيا برعاية جمعية وراد التـطوعي',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
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
      ],
    );
  }
}
