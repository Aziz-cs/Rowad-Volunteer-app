import 'package:app/chances/controller/chances_controller.dart';
import 'package:app/chances/view/edit_chance_page.dart';
import 'package:app/profile/controller/profile_controller.dart';
import 'package:app/utils/helper.dart';
import 'package:app/utils/sharedprefs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../../widgets/back_btn.dart';
import '../../widgets/simple_btn.dart';
import '../model/chance.dart';

class ChancePage extends StatelessWidget {
  ChancePage({
    Key? key,
    required this.chance,
  }) : super(key: key);

  Chance chance;

  @override
  Widget build(BuildContext context) {
    print('chance start: ${chance.startDate}');
    print('chance end: ${chance.endDate}');
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: SafeArea(
          child: Column(
            children: [
              _buildChanceHeadbar(context),
              _buildChanceInfo(),
              Divider(color: Colors.grey.shade800),
              _buildChanceDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildChanceDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نبذة عن الفرصة التطوعية',
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
                  chance.shortDesc,
                  style: TextStyle(
                    fontSize: 15.5.sp,
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
            onPress: () => Helper.openURL(chance.chanceURL),
          ),
        ],
      ),
    );
  }

  // _buildIconInfo(
  Widget _buildChanceInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 13.h),
                _buildIconInfo(
                  label: chance.organization,
                  iconData: CupertinoIcons.check_mark_circled_solid,
                ),
                SizedBox(height: 13.h),
                _buildIconInfo(
                  label: '${chance.area} | ${chance.city}',
                  iconData: CupertinoIcons.location_fill,
                ),
                SizedBox(height: 13.h),
                _buildIconInfo(
                  label: '${chance.sitsNo} متطوع',
                  iconData: CupertinoIcons.person_fill,
                ),
                SizedBox(height: 13.h),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.calendar_today,
                      color: kGreenColor,
                      size: 22,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      chance.startDate,
                      style: TextStyle(
                        color: Colors.black87,
                        height: 1,
                        fontSize: 12.4.sp,
                      ),
                    ),
                    if (chance.getDaysLeft() != 0)
                      Text(
                        ' إلى ${chance.endDate}',
                        style: TextStyle(
                          color: Colors.black87,
                          height: 1,
                          fontSize: 12.4.sp,
                        ),
                      ),
                  ],
                ),
                // _buildIconInfo(
                //   label: chance.startDate + ' --> ' + chance.endDate,
                //   iconData: CupertinoIcons.calendar_today,
                // ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 13.h),
                _buildIconInfo(
                  label: chance.getDaysLeft() == 0
                      ? 'اليوم'
                      : '${chance.getDaysLeft()} ${chance.getDaysWordinArabic()}',
                  iconData: CupertinoIcons.time_solid,
                ),
                SizedBox(height: 13.h),
                _buildIconInfo(
                  label: chance.requiredDegree,
                  iconData: Icons.bar_chart_sharp,
                ),
                SizedBox(height: 13.h),
                _buildIconInfo(
                  label: chance.gender,
                  iconData: chance.gender == kMales
                      ? Icons.male
                      : chance.gender == kFemales
                          ? Icons.female
                          : Icons.group,
                ),
              ],
            ),
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
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              height: 1,
              fontSize: 12.4.sp,
            ),
          ),
        ),
      ],
    );
  }

  Stack _buildChanceHeadbar(BuildContext context) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: chance.imageURL,
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
                  Colors.black.withOpacity(0.45),
                ],
                stops: const [
                  0.0,
                  0.7,
                ],
              )),
        ),
        Positioned(
          right: 5.w,
          child: BackBtn(),
        ),
        if (sharedPrefs.userRole == kAdmin ||
            sharedPrefs.userRole == kEditor ||
            sharedPrefs.userRole == kTeamLeader)
          Positioned(
              left: 4.w,
              child: IconButton(
                onPressed: () {
                  Get.to(() => EditChancePage(chance: chance));
                  // Get.defaultDialog(
                  //   title: 'تعديل الفرصة',
                  //   content: Column(
                  //     children: [],
                  //   ),
                  // ).then((value) {
                  //   setState(() {});
                  // });
                },
                icon: const Icon(
                  CupertinoIcons.pencil_circle_fill,
                  color: Colors.amber,
                  size: 30,
                ),
              )),
        Positioned(
          bottom: 16.h,
          right: 10.w,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 235.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chance.title,
                        style: TextStyle(
                          color: Colors.white,
                          height: 1,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        chance.organization,
                        style: TextStyle(
                          color: Colors.white,
                          height: 1,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 16.h,
          left: 10.w,
          child: SimpleButton(
            label: 'انضم للفرصة',
            onPress: () => Helper.openURL(chance.chanceURL),
          ),
        )
      ],
    );
  }
}
