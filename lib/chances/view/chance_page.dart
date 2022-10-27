import 'package:app/chances/controller/chances_controller.dart';
import 'package:app/chances/view/edit_chance_page.dart';
import 'package:app/utils/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../../widgets/back_btn.dart';
import '../../widgets/simple_btn.dart';
import '../model/chance.dart';

class ChancePage extends StatefulWidget {
  ChancePage({
    Key? key,
    required this.chance,
  }) : super(key: key);

  Chance chance;

  @override
  State<ChancePage> createState() => _ChancePageState();
}

class _ChancePageState extends State<ChancePage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
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
                  widget.chance.shortDesc,
                  style: TextStyle(
                    fontSize: 16.sp,
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
            onPress: () => Helper.openURL(widget.chance.chanceURL),
          ),
        ],
      ),
    );
  }

  // _buildIconInfo(
  Widget _buildChanceInfo() {
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
                label: widget.chance.organization,
                iconData: CupertinoIcons.check_mark_circled_solid,
              ),
              SizedBox(height: 13.h),
              _buildIconInfo(
                label: widget.chance.city,
                iconData: CupertinoIcons.location_fill,
              ),
              SizedBox(height: 13.h),
              _buildIconInfo(
                label: '${widget.chance.sitsNo} متطوع',
                iconData: CupertinoIcons.person_fill,
              ),
              SizedBox(height: 13.h),
              _buildIconInfo(
                label:
                    '${widget.chance.startDate} إلى ${widget.chance.endDate}',
                iconData: CupertinoIcons.calendar_today,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 13.h),
              _buildIconInfo(
                label:
                    '${widget.chance.getDaysLeft()} ${widget.chance.getDaysWordinArabic()}',
                iconData: CupertinoIcons.time_solid,
              ),
              SizedBox(height: 13.h),
              _buildIconInfo(
                label: widget.chance.requiredDegree,
                iconData: Icons.bar_chart_sharp,
              ),
              SizedBox(height: 13.h),
              _buildIconInfo(
                label: widget.chance.gender,
                iconData: widget.chance.gender == kMales
                    ? Icons.male
                    : widget.chance.gender == kFemales
                        ? Icons.female
                        : Icons.group,
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

  Stack _buildChanceHeadbar(BuildContext context) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: widget.chance.imageURL,
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
                  Colors.black.withOpacity(0.65),
                ],
                stops: const [
                  0.0,
                  0.7,
                ],
              )),
        ),
        Positioned(
          right: 5.w,
          child: const BackBtn(),
        ),
        Positioned(
            left: 4.w,
            child: IconButton(
              onPressed: () {
                Get.to(() => EditChance(chance: widget.chance));
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
                Icons.edit,
                color: Colors.white,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chance.title,
                      style: TextStyle(
                        color: Colors.white,
                        height: 1,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      widget.chance.organization,
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
            label: 'انضم للفرصة',
            onPress: () => Helper.openURL(widget.chance.chanceURL),
          ),
        )
      ],
    );
  }
}
