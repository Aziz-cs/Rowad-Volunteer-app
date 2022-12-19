import 'package:app/widgets/back_btn.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants.dart';
import '../../widgets/menu_drawer.dart';

class StatsPage extends StatelessWidget {
  StatsPage({
    Key? key,
  }) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuDrawer(),
      appBar: AppBar(
        backgroundColor: kGreenColor,
        leading: BackBtn(),
        leadingWidth: 200.w,
        //  IconButton(
        //     icon: const Icon(Icons.menu),
        //     onPressed: () {
        //       _scaffoldKey.currentState!.openDrawer();
        //     }),
        title: Text(
          'الأحصائيات',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('stats')
            .doc('stats')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var result = snapshot.data!.data();
            var resultMap = result as Map<String, dynamic>;
            print(resultMap);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  _buildStatsContainer(
                      title: 'عدد المتطوعين',
                      number: resultMap['volunteerNo'],
                      bgColor: kGreenColor),
                  _buildStatsContainer(
                    title: 'عدد أعضاء الجمعية',
                    number: resultMap['usersNo'],
                    bgColor: Colors.orange,
                  ),
                  _buildStatsContainer(
                    title: 'عدد الفرص التطوعية',
                    number: resultMap['chancesNo'],
                    bgColor: const Color(0xFF0391df),
                  ),
                  _buildStatsContainer(
                    title: 'عدد الساعات التطوعية',
                    number: resultMap['hoursNo'],
                    bgColor: Colors.green,
                  ),
                  _buildStatsContainer(
                    title: 'عدد الفرق التطوعية',
                    number: resultMap['teamsNo'],
                    bgColor: Colors.deepOrange,
                  ),
                  _buildStatsContainer(
                    title: 'عدد المتطوعين بالتكرار',
                    number: resultMap['volunteerRepeatedNo'],
                    bgColor: Colors.cyan,
                  ),
                  _buildStatsContainer(
                    title: 'العائد الاقتصادي',
                    number: resultMap['economicReturn'],
                    bgColor: Colors.grey,
                  ),
                  _buildStatsContainer(
                    title: 'عدد الدورات التدريبية',
                    number: resultMap['coursesNo'],
                    bgColor: Colors.lightBlue,
                  ),
                  _buildStatsContainer(
                    title: 'عدد الجهات المستفيدة',
                    number: resultMap['beneficalNo'],
                    bgColor: Colors.blueGrey,
                  ),
                ],
              ),
            );
          }
          return const CircularLoading();
        },
      ),
    );
  }

  Container _buildStatsContainer({
    required String title,
    required int number,
    required Color bgColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.bar_chart_outlined,
            color: Colors.white,
            size: 24,
          ),
          Flexible(
            child: Text(
              title,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Text(
            number.toString(),
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
