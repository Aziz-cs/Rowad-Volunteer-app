import 'package:app/teams/model/team.dart';
import 'package:app/teams/view/team_page.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/online_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class TeamItem extends StatelessWidget {
  TeamItem({
    Key? key,
    required this.team,
  }) : super(key: key);
  Team team;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: TeamPage(team: team),
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          children: [
            CachedOnlineIMG(
              imageURL: team.imageURL,
              imageHeight: 110,
              imageWidth: 110,
            ),
            const Spacer(),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 5.h),
              decoration: const BoxDecoration(
                color: kGreenColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                team.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  height: 1.2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
