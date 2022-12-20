import 'package:app/profile/controller/profile_controller.dart';
import 'package:app/profile/model/volunteer.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/circle_logo.dart';
import 'package:app/widgets/dropdown_menu.dart';
import 'package:app/widgets/online_img.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

const List<String> userRolesListAR = [
  kVolunteerAR,
  kEditorAR,
  kTeamLeaderAR,
  kAdminAR,
];

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.volunteer,
  });
  final Volunteer volunteer;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          leading: volunteer.avatarURL.isEmpty
              ? const RowadCircleLogo(
                  radius: 20,
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.2,
                    ),
                  ),
                  child: ClipOval(
                      child: CachedOnlineIMG(
                    imageURL: volunteer.avatarURL,
                    imageWidth: 35,
                    imageHeight: 35,
                  )),
                ),
          textColor: Colors.white,
          iconColor: Colors.white,
          collapsedBackgroundColor: kGreenColor.withOpacity(0.4),
          backgroundColor: kGreenColor,
          title: Text(volunteer.name),
          subtitle: Text(volunteer.email),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'تاريخ التسجيل:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        volunteer.getDate(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الجنس:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        volunteer.isMale ? 'ذكر' : 'انثى',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'تاريخ الميلاد:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        volunteer.birthday,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'رقم الجوال:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        volunteer.phoneNo,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المدينة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        volunteer.city,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المؤهل العلمي:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        volunteer.educationDegree,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'التخصص:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        volunteer.specialization,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  if (volunteer.socialState.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الحالة الاجتماعية:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          volunteer.socialState,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'مستوى التطوع:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        volunteer.volunteerLevel,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'صلاحية العضو:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 90.w,
                        child: DropDownMenu(
                            arrowColor: Colors.white,
                            // dropdowncolor: Colors.orange.shade300,
                            isBold: true,
                            fontSize: 14.sp,
                            textColor: Colors.white,
                            value: getUserRoleInAROf(volunteer.userRole),
                            items: userRolesListAR,
                            onChanged: (changedValue) {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(volunteer.id)
                                  .update({
                                'userRole': getUserRoleInENOf(changedValue!),
                              }).then((value) => Fluttertoast.showToast(
                                      msg: 'تم تعديل الصلاحية'));
                            }),
                      )
                      // Text(
                      //   getUserRoleInAROf(volunteer.userRole),
                      //   style: TextStyle(
                      //     color: Colors.orange.shade200,
                      //     fontSize: 14.sp,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
