import 'package:app/courses/model/course.dart';
import 'package:app/courses/view/edit_course_page.dart';
import 'package:app/utils/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../../widgets/back_btn.dart';
import '../../widgets/simple_btn.dart';

class CoursePage extends StatelessWidget {
  CoursePage({
    Key? key,
    required this.course,
  }) : super(key: key);

  Course course;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildCourseHeadbar(context),
                _buildCourseInfo(),
                Divider(color: Colors.grey.shade800),
                _buildCourseDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildCourseDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفاصيل الدورة التدريبية',
            style: TextStyle(
              fontSize: 17.sp,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Flexible(
                child: Text(
                  course.details,
                  style: TextStyle(
                    fontSize: 15.5.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // _buildIconInfo(
  Widget _buildCourseInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 13.h),
              _buildIconInfo(
                label: course.name,
                iconData: Icons.class_,
              ),
              SizedBox(height: 13.h),
              _buildIconInfo(
                label: course.startDate,
                iconData: CupertinoIcons.calendar,
              ),
              SizedBox(height: 13.h),
              _buildIconInfo(
                label: '${course.duration} أيام',
                iconData: Icons.timer_outlined,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 13.h),
              _buildIconInfo(
                label: course.instructorName,
                iconData: Icons.person,
              ),
              SizedBox(height: 13.h),
              _buildIconInfo(
                label: '${course.startHour} ${course.isAMorPM}',
                iconData: CupertinoIcons.time_solid,
              ),
              SizedBox(height: 13.h),
              _buildIconInfo(
                label: course.owner,
                iconData: CupertinoIcons.check_mark_circled_solid,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildIconInfo({
    required String label,
    required IconData iconData,
  }) {
    return Row(
      children: [
        Icon(
          iconData,
          color: kGreenColor,
          size: 22,
        ),
        SizedBox(width: 5.w),
        Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            height: 1,
            fontSize: 12.4.sp,
          ),
        ),
      ],
    );
  }

  Stack _buildCourseHeadbar(BuildContext context) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: course.imageURL,
          fit: BoxFit.fill,
          height: 210.h,
          width: double.infinity,
          placeholder: (context, url) => Padding(
            padding: const EdgeInsets.all(30.0),
            child: Image.asset('assets/images/loading_spinner.gif'),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.error,
            color: kGreenColor,
          ),
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
                  Colors.black.withOpacity(0.75),
                ],
                stops: const [
                  0.0,
                  0.5,
                ],
              )),
        ),
        Positioned(
          right: 5.w,
          child: BackBtn(),
        ),
        Positioned(
            left: 4.w,
            child: IconButton(
              onPressed: () {
                Get.to(() => EditCoursePage(course: course));
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            )),
        Positioned(
          bottom: 16.h,
          right: 10.w,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              width: 235.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: TextStyle(
                      color: Colors.white,
                      height: 1,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    course.intro,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      height: 1,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16.h,
          left: 10.w,
          child: course.isRegisterationOpen
              ? SimpleButton(
                  label: 'سجل الآن',
                  onPress: () => Helper.openURL(course.registerationURL),
                )
              : SimpleButton(
                  backgroundColor: Colors.red.shade700,
                  label: 'التسجيل مغلق',
                  onPress: () => Helper.openURL(course.registerationURL),
                ),
        )
      ],
    );
  }
}
