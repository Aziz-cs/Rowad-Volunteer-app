import 'package:app/profile/controller/profile_controller.dart';
import 'package:app/utils/sharedprefs.dart';
import 'package:app/widgets/back_btn.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:app/widgets/simple_btn.dart';
import 'package:app/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

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
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  _buildStatsContainer(
                    key: 'volunteerNo',
                    title: 'عدد المتطوعين',
                    number: resultMap['volunteerNo'],
                    bgColor: kGreenColor,
                  ),
                  _buildStatsContainer(
                    key: 'usersNo',
                    title: 'عدد أعضاء الجمعية',
                    number: resultMap['usersNo'],
                    bgColor: Colors.orange,
                  ),
                  _buildStatsContainer(
                    key: 'chancesNo',
                    title: 'عدد الفرص التطوعية',
                    number: resultMap['chancesNo'],
                    bgColor: const Color(0xFF0391df),
                  ),
                  _buildStatsContainer(
                    key: 'hoursNo',
                    title: 'عدد الساعات التطوعية',
                    number: resultMap['hoursNo'],
                    bgColor: Colors.green,
                  ),
                  _buildStatsContainer(
                    key: 'teamsNo',
                    title: 'عدد الفرق التطوعية',
                    number: resultMap['teamsNo'],
                    bgColor: Colors.deepOrange,
                  ),
                  _buildStatsContainer(
                    key: 'volunteerRepeatedNo',
                    title: 'عدد المتطوعين بالتكرار',
                    number: resultMap['volunteerRepeatedNo'],
                    bgColor: Colors.cyan,
                  ),
                  _buildStatsContainer(
                    key: 'economicReturn',
                    title: 'العائد الاقتصادي',
                    number: resultMap['economicReturn'],
                    bgColor: Colors.grey,
                  ),
                  _buildStatsContainer(
                    key: 'coursesNo',
                    title: 'عدد الدورات التدريبية',
                    number: resultMap['coursesNo'],
                    bgColor: Colors.lightBlue,
                  ),
                  _buildStatsContainer(
                    key: 'beneficalNo',
                    title: 'عدد الجهات المستفيدة',
                    number: resultMap['beneficalNo'],
                    bgColor: Colors.blueGrey,
                  ),
                ],
              ),
            );
          }
          return CircularLoading();
        },
      ),
    );
  }

  Container _buildStatsContainer({
    required String title,
    required String key,
    required int number,
    required Color bgColor,
  }) {
    var controller = TextEditingController();
    var _formKey = GlobalKey<FormState>();
    controller.text = number.toString();
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
          sharedPrefs.userRole == kAdmin ||
                  sharedPrefs.userRole == kEditor ||
                  sharedPrefs.userRole == kTeamLeader
              ? InkWell(
                  onTap: () => Get.defaultDialog(
                    backgroundColor: bgColor,
                    title: 'تعديل الإحصائية',
                    titleStyle:
                        const TextStyle(fontSize: 20, color: Colors.white),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: Form(
                                key: _formKey,
                                child: MyTextField(
                                  isLTRdirection: true,
                                  controller: controller,
                                  inputType: TextInputType.number,
                                  validator: (input) {
                                    if (input!.isEmpty) {
                                      return kErrEmpty;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        SimpleButton(
                          backgroundColor: bgColor.withOpacity(0.3),
                          label: 'تعديل',
                          onPress: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            FirebaseFirestore.instance
                                .collection('stats')
                                .doc('stats')
                                .update({
                              key: int.parse(controller.text.trim()),
                            });
                            Get.back();
                            Fluttertoast.showToast(msg: 'تم التعديل بنجاح');
                          },
                        ),
                        const SizedBox(height: 5),
                        SimpleButton(
                          backgroundColor: bgColor.withOpacity(0.3),
                          label: 'إلغاء',
                          onPress: () {},
                        ),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 7),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      Icon(
                        Icons.bar_chart_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 20)
                    ],
                  ),
                )
              : const Icon(
                  Icons.bar_chart_outlined,
                  color: Colors.white,
                  size: 24,
                ),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Text(
            number.toString(),
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
