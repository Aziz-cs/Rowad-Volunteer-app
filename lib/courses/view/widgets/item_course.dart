import 'package:app/courses/model/course.dart';
import 'package:app/courses/view/courses_page.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/helper.dart';
import 'package:app/widgets/online_img.dart';
import 'package:app/widgets/simple_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../course_page.dart';

class CourseItem extends StatelessWidget {
  CourseItem({
    Key? key,
    required this.course,
  }) : super(key: key);

  Course course;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: CoursePage(course: course),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      ),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 5.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        CachedOnlineIMG(imageURL: course.imageURL),
                        Positioned(
                          top: 0,
                          right: 2.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            color: Colors.black45,
                            child: Text(
                              getFormatedDate(course.timestamp),
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 5.w, right: 5.w, bottom: 5.h),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: kGreenColor,
                          ),
                          child: Text(
                            course.name,
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 13.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.intro,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey.shade600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'تاريخ البدء:',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: kGreenColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    course.startDate,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'المدة:',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: kGreenColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${course.duration} أيام',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            Text(
              course.details,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5.h),
            SimpleButton(
              label: 'اقرأ المزيد',
              onPress: () => PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: CoursePage(course: course),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
