import 'package:app/view/opportunity_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../tabs/opportunities_page.dart';

class OpportunityItem extends StatelessWidget {
  const OpportunityItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.green,
      onTap: () {
        pushNewScreen(
          context,
          screen: const OpportunityPage(),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/opportunity_kids.jpeg',
                fit: BoxFit.fill,
              ),
              SizedBox(height: 5.h),
              Text(
                'مراقب مجتمعي',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'أمانة منطقة جازان',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 7.h),
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.calendar_today,
                    size: 20,
                    color: Colors.green,
                  ),
                  SizedBox(width: 5.w),
                  Flexible(
                    child: Text(
                      '١ مارس إلى ١٠ مارس',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 13.h),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  _buildIconTitleRow(
                    title: '١٠ أيــام',
                    iconData: CupertinoIcons.time_solid,
                  ),
                  SizedBox(width: 7.w),
                  _buildIconTitleRow(
                    title: 'جازان',
                    iconData: CupertinoIcons.location_fill,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Row _buildIconTitleRow({required String title, required IconData iconData}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        iconData,
        size: 24,
        color: Colors.green,
      ),
      SizedBox(width: 3.w),
      Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey.shade600,
        ),
      ),
    ],
  );
}