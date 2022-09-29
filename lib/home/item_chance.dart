import 'package:app/chances/chance_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ChanceItem extends StatelessWidget {
  const ChanceItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: const ChancePage(),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        child: Container(
          width: 140.w,
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/opportunity_kids.jpeg',
                ),
                SizedBox(height: 1.h),
                Text(
                  'مراقب مجتمعي',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'أمانة منطقة جازان',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2.h),
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
                SizedBox(height: 3.h),
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
