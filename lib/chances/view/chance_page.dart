import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widgets/simple_btn.dart';

const String opportunityDetails = 'هذا النص الذي يعطي نبذة عن الفرصة التطوعية ';

class ChancePage extends StatelessWidget {
  const ChancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
        body: SafeArea(
          child: Column(
            children: [
              _buildOpportunityHeadbar(context),
              _buildOpportunityInfo(),
              Divider(color: Colors.grey.shade800),
              _buildOppertunityDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildOppertunityDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نبذة عن الفرصة التطوعية',
            style: TextStyle(
              fontSize: 15.5.sp,
              color: Colors.black54,
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
                      opportunityDetails,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 7.h),
          Divider(color: Colors.grey.shade800),
          Text(
            'رابط الفرصة على المنصة',
            style: TextStyle(
              fontSize: 15.5.sp,
            ),
          ),
          SizedBox(height: 7.h),
          SimpleButton(
            label: 'انضم للفرصة من خلال المنصة',
            onPress: () {},
          ),
        ],
      ),
    );
  }

  // _buildIconInfo(
  //   title: '١٠ أيام',
  //   iconData: CupertinoIcons.timer_fill,
  // ),
  Widget _buildOpportunityInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 13.h),
              _buildIconInfo(
                title: 'جمعية رواد للعمل التطوعي',
                iconData: CupertinoIcons.check_mark_circled_solid,
              ),
              SizedBox(height: 13.h),
              _buildIconInfo(
                title: 'الجهة الشرقية - جدة',
                iconData: CupertinoIcons.location_fill,
              ),
              SizedBox(height: 13.h),
              _buildIconInfo(
                title: '22-9-2022 إلى 2022-10-1',
                iconData: CupertinoIcons.calendar_today,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 13.h),
              _buildIconInfo(
                title: '١٠ أيام',
                iconData: CupertinoIcons.time_solid,
              ),
              SizedBox(height: 13.h),
              _buildIconInfo(
                title: '75 متطوع',
                iconData: CupertinoIcons.person_fill,
              ),
              SizedBox(height: 13.h),
              _buildIconInfo(
                title: 'مؤهل عالى - دبلومة فنية',
                iconData: Icons.bar_chart_sharp,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildIconInfo({
    required String title,
    required IconData iconData,
  }) {
    return Row(
      children: [
        Icon(
          iconData,
          color: Colors.grey.shade400,
          size: 22,
        ),
        SizedBox(width: 5.w),
        Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            height: 1,
            fontSize: 12.4.sp,
          ),
        ),
      ],
    );
  }

  Stack _buildOpportunityHeadbar(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                'assets/images/volunteer_help.png',
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
            onTap: () => Navigator.pop(context),
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
          right: 10.w,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التطوع لتوزيع الطعام بالمنازل',
                      style: TextStyle(
                        color: Colors.white,
                        height: 1,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'جمعية رواد للعمل التطوعي',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        height: 1,
                        fontSize: 13.sp,
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
              label: 'انضم للفرصة', onPress: () => print('join change')),
        )
      ],
    );
  }
}
