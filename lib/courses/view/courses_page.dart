import 'package:app/courses/model/course.dart';
import 'package:app/courses/view/widgets/item_course.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:app/widgets/menu_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants.dart';

class CoursesPage extends StatelessWidget {
  CoursesPage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuDrawer(),
      appBar: AppBar(
        backgroundColor: kGreenColor,
        title: Text(
          'الدورات التدريبية',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            }),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: ((context, snapshot) {
                  List<CourseItem> coursesItems = [];
                  print(snapshot.connectionState.toString());
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasError) {
                      print('has error in loading news');
                      return const Center(child: Text('هناك خطأ ما'));
                    }
                    var coursesResult = snapshot.data!.docs;
                    coursesResult.forEach(
                      (courseElement) {
                        Course course = Course.fromDB(
                          courseElement.data() as Map<String, dynamic>,
                          courseElement.id,
                        );
                        coursesItems.add(CourseItem(course: course));
                      },
                    );
                    return Column(
                      children: coursesItems.reversed.toList(),
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
