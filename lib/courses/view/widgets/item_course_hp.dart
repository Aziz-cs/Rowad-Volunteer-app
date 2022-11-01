import 'package:app/courses/model/course.dart';
import 'package:app/courses/view/course_page.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/online_img.dart';
import 'package:app/widgets/simple_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class CourseItemHP extends StatelessWidget {
  CourseItemHP({
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
        width: 160.w,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
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
              child: Stack(
                children: [
                  SizedBox(
                      height: 100.h,
                      child: CachedOnlineIMG(
                        imageURL: course.imageURL,
                      )),
                  Container(
                    height: 100.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.centerRight,
                          colors: [
                            Colors.grey.withOpacity(0.0),
                            Colors.black.withOpacity(0.50),
                          ],
                          stops: const [
                            0.0,
                            0.5,
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.h),
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
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Column(
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
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          const Spacer(),
                          // SizedBox(
                          //   height: 30.h,
                          //   child: SimpleButton(
                          //     label: 'سجل الآن',
                          //     onPress: () {},
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                    child: SimpleButton(
                      label: 'اقرأ المزيد',
                      onPress: () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: CoursePage(course: course),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
