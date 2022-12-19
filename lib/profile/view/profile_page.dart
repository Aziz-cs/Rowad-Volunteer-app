import 'package:app/profile/controller/profile_controller.dart';
import 'package:app/profile/model/volunteer.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/circle_logo.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:app/widgets/menu_drawer.dart';
import 'package:app/widgets/online_img.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuDrawer(),
      appBar: AppBar(
        backgroundColor: kGreenColor,
        leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            }),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'حسابك الشخصي',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.filter_list,
                color: kGreenColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      Map<String, dynamic> result =
                          snapshot.data!.data() as Map<String, dynamic>;
                      Volunteer volunteer =
                          Volunteer.fromDB(result, snapshot.data!.id);
                      print(result);
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              profileController.pickImage();
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipOval(
                                  child: CachedOnlineIMG(
                                    imageURL: volunteer.avatarURL.isEmpty
                                        ? 'https://firebasestorage.googleapis.com/v0/b/rowad-774e0.appspot.com/o/avatar.png?alt=media&token=143096fd-3145-4a5f-a148-ae673d366b1e'
                                        : volunteer.avatarURL,
                                    imageWidth: 100,
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 15,
                                  child: Icon(
                                    CupertinoIcons.camera_fill,
                                    color: Colors.grey.shade800,
                                  ),
                                )
                              ],
                            ),
                          ),
                          buildTextViewContainer(
                            label: 'الأسم',
                            text: volunteer.name,
                            onTap: () => showEditOneParamaterDialog(
                              dialogTitle: 'تعديل الأسم',
                              currentValue: volunteer.name,
                              documentFieldKey: 'name',
                            ),
                          ),
                          buildTextViewContainer(
                            label: 'الإيميل',
                            text: volunteer.email,
                            isEditable: false,
                          ),
                          buildTextViewContainer(
                            label: 'رقم الجوال',
                            text: volunteer.phoneNo,
                            isLTR: true,
                            onTap: () => showEditOneParamaterDialog(
                              dialogTitle: 'تعديل رقم الجوال',
                              currentValue: volunteer.phoneNo,
                              documentFieldKey: 'phoneNo',
                              textInputType: TextInputType.phone,
                              isLTR: true,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextViewContainer(
                                  label: 'المنطقة',
                                  text: volunteer.area,
                                  onTap: () => showEditOneParamaterDialog(
                                    dialogTitle: 'تعديل المنطقة',
                                    currentValue: volunteer.area,
                                    documentFieldKey: 'area',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: buildTextViewContainer(
                                  label: 'المدينة',
                                  text: volunteer.city,
                                  onTap: () => showEditOneParamaterDialog(
                                    dialogTitle: 'تعديل المدينة',
                                    currentValue: volunteer.city,
                                    documentFieldKey: 'city',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextViewContainer(
                                  label: 'الجنس',
                                  text: volunteer.isMale ? 'ذكر' : 'انثى',
                                ),
                              ),
                              Expanded(
                                child: buildTextViewContainer(
                                  label: 'مستوى التطوع',
                                  text: volunteer.volunteerLevel,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextViewContainer(
                                  label: 'المؤهل العلمي',
                                  text: volunteer.educationDegree,
                                ),
                              ),
                              Expanded(
                                child: buildTextViewContainer(
                                  label: 'التخصص',
                                  text: volunteer.specialization,
                                  onTap: () => showEditOneParamaterDialog(
                                    dialogTitle: 'تعديل التخصص',
                                    currentValue: volunteer.specialization,
                                    documentFieldKey: 'specialization',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          buildTextViewContainer(
                            label: 'رقم الهوية',
                            text: volunteer.nationalID,
                            isLTR: true,
                            onTap: () => showEditOneParamaterDialog(
                              dialogTitle: 'تعديل رقم الهوية',
                              currentValue: volunteer.nationalID,
                              documentFieldKey: 'nationalID',
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextViewContainer(
                                  label: 'الجنسية',
                                  text: volunteer.nationality,
                                  onTap: () => showEditOneParamaterDialog(
                                    dialogTitle: 'تعديل الجنسية',
                                    currentValue: volunteer.nationality,
                                    documentFieldKey: 'nationality',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: buildTextViewContainer(
                                  label: 'الحالة الاجتماعية',
                                  text: volunteer.socialState,
                                  onTap: () => showEditOneParamaterDialog(
                                    dialogTitle: 'تعديل الحالة الاجتماعية',
                                    currentValue: volunteer.socialState,
                                    documentFieldKey: 'socialState',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextViewContainer(
                                  label: 'قطاع العمل',
                                  text: volunteer.workType,
                                ),
                              ),
                              Expanded(
                                child: buildTextViewContainer(
                                  label: 'المهنة',
                                  text: volunteer.job,
                                  onTap: () => showEditOneParamaterDialog(
                                    dialogTitle: 'تعديل المهنة',
                                    currentValue: volunteer.job,
                                    documentFieldKey: 'job',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => print('open edit dialog'),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('اللغات:'),
                                    Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                      size: 17,
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: List.generate(
                                    volunteer.languages.length,
                                    (index) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          volunteer.languages.keys
                                              .elementAt(index),
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                        Text(
                                          volunteer.languages.values
                                              .elementAt(index),
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                const Divider(
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 2.h),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const [
                                                Text('المهارات:'),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.grey,
                                                    size: 17,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: List.generate(
                                                volunteer.skillsList.length,
                                                (index) => Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      volunteer
                                                          .skillsList[index],
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        color: const Color(
                                                            0xFF87a594),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const VerticalDivider(
                                        color: Colors.grey,
                                        endIndent: 0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const [
                                                Text('الاهتمامات:'),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.grey,
                                                    size: 17,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: List.generate(
                                                volunteer.interestsList.length,
                                                (index) => Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      volunteer
                                                          .interestsList[index],
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: const Color(
                                                            0xFF87a594),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                        ],
                      );
                    }

                    return const CircularLoading();
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextViewContainer({
    required String label,
    required String text,
    bool isLTR = false,
    bool isEditable = true,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.only(right: 20.w),
              alignment: Alignment.centerRight,
              width: double.infinity,
              height: 40.h,
              decoration: BoxDecoration(
                  color: isEditable ? Colors.white : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  )),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: isLTR
                      ? [
                          if (isEditable)
                            const Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 17,
                            ),
                          Text(
                            text,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                        ]
                      : [
                          Text(
                            text,
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                          if (isEditable)
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                                size: 17,
                              ),
                            ),
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
