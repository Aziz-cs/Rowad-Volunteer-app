import 'package:app/notifications/model/notification.dart';
import 'package:app/notifications/view/item_notification.dart';
import 'package:app/widgets/back_btn.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants.dart';
import '../../widgets/menu_drawer.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({
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
        title: Text(
          'جميع الإشعارات',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<GlobalNotification> globalNotificationsList = [];
            var resultDocs = snapshot.data!.docs;

            resultDocs.forEach((element) {
              GlobalNotification notification = GlobalNotification.fromDB(
                element.data() as Map<String, dynamic>,
                element.id,
              );
              globalNotificationsList.add(notification);
            });
            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                  globalNotificationsList.length,
                  (index) => NotificationItem(
                    notification: globalNotificationsList[index],
                  ),
                ),
              ),
            );
          }
          return const CircularLoading();
        },
      ),
    );
  }
}
