import 'package:app/notifications/controller/notification_controller.dart';
import 'package:app/profile/model/volunteer.dart';
import 'package:app/teams/controller/team_controller.dart';
import 'package:app/teams/model/team.dart';
import 'package:app/teams/view/widgets/item_team.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:app/widgets/simple_btn.dart';
import 'package:app/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class TeamLeaderPanel extends StatelessWidget {
  TeamLeaderPanel({
    Key? key,
  }) : super(key: key);

  var teamController = Get.find<TeamController>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('teams')
          .where('teamLeaderID',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var result = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          Team team = Team.fromDB(result, snapshot.data!.docs.first.id);
          return Column(
            children: [
              SizedBox(
                width: 150.w,
                height: 150.h,
                child: TeamItem(team: team),
              ),
              SizedBox(height: 10.h),
              ExpansionTile(
                initiallyExpanded: true,
                collapsedBackgroundColor: kGreenColor,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                backgroundColor: kGreenColor,
                title: Text(
                  'طلبات الإنضمام للفريق',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                  ),
                ),
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('teams')
                          .doc(team.id)
                          .collection('pendingMembers')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          var result = snapshot.data!.docs;
                          return Obx(
                            () => teamController.isLoadingTeamDecision.isTrue
                                ? Center(
                                    child: CircularLoading(
                                      color: Colors.white,
                                    ),
                                  )
                                : Column(
                                    children: result
                                        .map(
                                          (e) =>
                                              FutureBuilder<DocumentSnapshot>(
                                            future: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(e.id)
                                                .get(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                var userResult =
                                                    snapshot.data!.data()
                                                        as Map<String, dynamic>;
                                                Volunteer volunteer =
                                                    Volunteer.fromDB(userResult,
                                                        snapshot.data!.id);
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    volunteer
                                                                        .name,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    volunteer
                                                                        .email,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13.sp,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 85.w,
                                                                child:
                                                                    SimpleButton(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .blue,
                                                                  label:
                                                                      'موافقة',
                                                                  onPress: () {
                                                                    teamController.acceptPendingMember(
                                                                        team:
                                                                            team,
                                                                        volunteer:
                                                                            volunteer);
                                                                  },
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 4.w),
                                                              SizedBox(
                                                                width: 85.w,
                                                                child:
                                                                    SimpleButton(
                                                                  backgroundColor:
                                                                      Colors.red
                                                                          .shade500,
                                                                  label: 'رفض',
                                                                  onPress: () {
                                                                    teamController.refusePendingMember(
                                                                        team:
                                                                            team,
                                                                        volunteer:
                                                                            volunteer);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                              return Center(
                                                  child: CircularLoading());
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ),
                          );
                        }
                        return Center(
                            child: CircularLoading(color: Colors.white));
                      }),
                ],
              ),
              ListTile(
                leading: const Icon(
                  Icons.notifications,
                ),
                title: const Text('ارسال إشعار للفريق'),
                subtitle: const Text('ارسال اشعار لأعضاء الفريق'),
                trailing: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 15,
                ),
                onTap: () {
                  final _formKey = GlobalKey<FormState>();
                  var titleController = TextEditingController();
                  var bodyController = TextEditingController();
                  Get.defaultDialog(
                    title: 'ارسال إشعار للفريق',
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4.h),
                              Center(
                                child: Text(
                                  'ارسال إشعار للفريق',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      color: kGreenColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              const Text('عنوان الإشعار'),
                              MyTextField(
                                controller: titleController,
                                validator: (input) {},
                              ),
                              SizedBox(height: 4.h),
                              const Text('الإشعار'),
                              MyTextField(
                                controller: bodyController,
                                maxLines: 3,
                                validator: (input) {},
                              ),
                              SizedBox(height: 4.h),
                              Obx(() => teamController
                                      .isLoadingSendingNotification.isTrue
                                  ? Center(child: CircularLoading())
                                  : SimpleButton(
                                      label: 'ارسال',
                                      onPress: () async {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        sendInternalNotification(
                                          title:
                                              '${team.name} | ${titleController.text.trim()}',
                                          body: bodyController.text.trim(),
                                          targetTopics: [
                                            team.id,
                                          ],
                                        );
                                        sendPushNotification(
                                          title:
                                              '${team.name} | ${titleController.text.trim()}',
                                          body: bodyController.text.trim(),
                                          topicName: team.id,
                                        );

                                        Fluttertoast.showToast(
                                            msg: 'تم ارسال الإشعار بنجاح');

                                        Get.back();
                                      },
                                    )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Divider(
                color: Colors.grey,
                height: 4.h,
              ),
            ],
          );
        }
        return CircularLoading();
      },
    );
  }
}
