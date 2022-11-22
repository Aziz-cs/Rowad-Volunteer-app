import 'package:app/teams/model/team.dart';
import 'package:app/teams/view/widgets/item_team.dart';
import 'package:app/widgets/menu_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/constants.dart';
import '../../widgets/circular_loading.dart';

class TeamsPage extends StatelessWidget {
  TeamsPage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const MenuDrawer(),
        appBar: AppBar(
          backgroundColor: kGreenColor,
          leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              }),
          title: Text(
            'الفرق التطوعية',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            // IconButton(
            //   icon: const Icon(
            //     Icons.filter_list,
            //     color: Colors.white,
            //   ),
            //   onPressed: () {},
            // ),
          ],
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('teams')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: ((context, snapshot) {
                  List<TeamItem> teamItems = [];
                  print(snapshot.connectionState.toString());
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasError) {
                      print('has error in loading news');
                      return const Center(child: Text('هناك خطأ ما'));
                    }
                    var teamsData = snapshot.data!.docs;
                    teamsData.forEach(
                      (teamElement) {
                        Team team = Team.fromDB(
                          teamElement.data() as Map<String, dynamic>,
                          teamElement.id,
                        );
                        teamItems.add(TeamItem(
                          team: team,
                        ));
                      },
                    );
                    return Expanded(
                      child: GridView.count(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: teamItems.reversed.toList(),
                      ),
                    );
                  }
                  return Column(
                    children: const [
                      Center(child: CircularLoading()),
                    ],
                  );
                }),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
