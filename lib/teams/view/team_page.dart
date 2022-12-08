import 'package:app/chances/controller/chances_controller.dart';
import 'package:app/chances/view/edit_chance_page.dart';
import 'package:app/teams/view/edit_team_page.dart';
import 'package:app/utils/helper.dart';
import 'package:app/widgets/online_img.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../../widgets/back_btn.dart';
import '../../widgets/simple_btn.dart';
import '../model/team.dart';

class TeamPage extends StatelessWidget {
  TeamPage({
    Key? key,
    required this.team,
  }) : super(key: key);

  Team team;

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
                _buildTeamHeadbar(context),
                _buildTeamInfo(),
                const Divider(color: Colors.grey),
                _buildTeamTitleDesc(title: 'نبذه عن الفريق', desc: team.brief),
                if (team.goals.isNotEmpty)
                  _buildTeamTitleDesc(title: 'الأهداف', desc: team.goals),
                if (team.futurePlans.isNotEmpty)
                  _buildTeamTitleDesc(
                      title: 'الخطط المستقبلية', desc: team.futurePlans),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildTeamTitleDesc({
    required String title,
    required String desc,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Flexible(
                child: Text(
                  desc,
                  style: TextStyle(
                    fontSize: 15.5.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  // _buildIconInfo(
  Widget _buildTeamInfo() {
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
              // _buildIconInfo(
              //   label: team.category,
              //   iconData: Icons.folder,
              // ),
              _buildIconInfo(
                label: 'قائد الفريق:',
                iconData: CupertinoIcons.star_circle_fill,
              ),
              if (team.deputyName.isNotEmpty)
                _buildIconInfo(
                  label: 'نائب الفريق:',
                  iconData: CupertinoIcons.person_crop_square_fill,
                ),
              if (team.econmicName.isNotEmpty)
                _buildIconInfo(
                  label: 'المسؤول المالي',
                  iconData: CupertinoIcons.money_dollar_circle_fill,
                ),
              if (team.mediaName.isNotEmpty)
                _buildIconInfo(
                  label: 'المسؤول الإعلامي',
                  iconData: CupertinoIcons.tv_circle_fill,
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 13.h),
              // _buildIconInfo(
              //   label: '25 متطوع',
              //   iconData: Icons.group,
              // ),
              _buildIconInfo(
                label: team.teamLeaderName,
                iconData: Icons.person,
              ),
              if (team.deputyName.isNotEmpty)
                _buildIconInfo(
                  label: team.deputyName,
                  iconData: Icons.person,
                ),
              if (team.econmicName.isNotEmpty)
                _buildIconInfo(
                  label: team.econmicName,
                  iconData: Icons.person,
                ),
              if (team.mediaName.isNotEmpty)
                _buildIconInfo(
                  label: team.mediaName,
                  iconData: Icons.person,
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
            fontSize: 12.5.sp,
          ),
        ),
      ],
    );
  }

  Row _buildUserRole({
    required String label,
    required String userName,
    // required IconData iconData,
  }) {
    return Row(
      children: [
        const Icon(
          Icons.person,
          color: kGreenColor,
          size: 22,
        ),
        SizedBox(width: 5.w),
        Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            height: 1,
            fontSize: 12.5.sp,
          ),
        ),
        SizedBox(width: 5.w),
        Text(
          userName,
          style: TextStyle(
            color: Colors.black,
            height: 1,
            fontWeight: FontWeight.w500,
            fontSize: 12.5.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamHeadbar(BuildContext context) {
    return Container(
      // color: Colors.white,
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackBtn(isBlack: true),
              IconButton(
                onPressed: () {
                  Get.to(() => EditTeamPage(team: team));
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.black54,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedOnlineIMG(
                imageURL: team.imageURL,
                imageHeight: 125,
                imageWidth: 125,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _buildIconInfo(
                      label: team.category,
                      iconData: Icons.folder,
                    ),
                    _buildIconInfo(
                      label: '25 متطوع',
                      iconData: Icons.group,
                    ),
                  ],
                ),
                SimpleButton(
                  label: 'انضم للفريق',
                  onPress: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
