import 'package:app/admin/view/admin_panel_page.dart';
import 'package:app/notifications/controller/notification_controller.dart';
import 'package:app/widgets/back_btn.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:app/widgets/navigator_page.dart';
import 'package:app/widgets/simple_btn.dart';
import 'package:app/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../utils/constants.dart';
import '../../widgets/menu_drawer.dart';
import 'package:get/get.dart';

class SendNotificationPage extends StatelessWidget {
  SendNotificationPage({
    Key? key,
  }) : super(key: key);
  var notificationController = Get.put(NotificationController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var bodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const MenuDrawer(),
        appBar: AppBar(
          backgroundColor: kGreenColor,
          leading: BackBtn(),
          leadingWidth: 200.w,
          title: Text(
            'الإشعارات',
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Center(
                  child: Text(
                    'ارسال إشعار عام',
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
                Obx(() => notificationController.isSending.isTrue
                    ? Center(child: CircularLoading())
                    : SimpleButton(
                        label: 'ارسال',
                        onPress: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          notificationController.isSending.value = true;

                          sendInternalNotification(
                            title: titleController.text.trim(),
                            body: bodyController.text.trim(),
                            targetTopics: [
                              kGlobalNotifications,
                            ],
                          );

                          await sendPushNotification(
                              title: titleController.text.trim(),
                              body: bodyController.text.trim(),
                              topicName: 'global');

                          notificationController.isSending.value = false;
                          Fluttertoast.showToast(msg: 'تم ارسال الإشعار بنجاح');

                          Get.offAll(() => NavigatorPage());
                        },
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
