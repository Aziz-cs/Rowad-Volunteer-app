import 'dart:convert';

import 'package:app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

const String kServerKey =
    'AAAACPC8WIg:APA91bE73CHOZkl91M41p1ztIjidcq7IrA-m51yrKiaOpAWDIwCnmCjQb-bsu0P9Wy4LvfbJHsLdlmwsL7wLxOJltc4URJwfdedKL544l14TSn_n1mM6S7BctJP0gu3xHb00j0DuvhcP';
const String kGlobalNotifications = 'global';

class NotificationController extends GetxController {
  var isSending = false.obs;
}

Future<void> sendInternalNotification({
  required String title,
  required String body,
  required List<String> targetTopics,
}) async {
  // isSending.value = true;
  await FirebaseFirestore.instance.collection('notifications').add({
    'title': title,
    'body': body,
    'targetTopics': targetTopics,
    'timestamp': FieldValue.serverTimestamp(),
  }).catchError((e) {
    Fluttertoast.showToast(msg: kErrSomethingWrong);
  });
}

Future<void> sendPushNotification({
  required String title,
  required String body,
  required String topicName,
}) async {
  var serverKey = kServerKey;
  // QuerySnapshot ref =
  //     await FirebaseFirestore.instance.collection('users').get();
  try {
    await http
        .post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': body,
                'title': title,
                "sound": "default",
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              "to": "/topics/$topicName",
            },
          ),
        )
        .then((value) {});
  } catch (e) {
    print("error push notification");
  }
}

void subscribeUserToTopic({
  required String userID,
  required String topicName,
}) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('subscribedTopics')
      .add({
    'topicName': topicName,
  });
  print('User ($userID) has been added to team ($topicName) notifications');
}

void unSubscribeUserFromTopic({
  required String userID,
  required String topicName,
}) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('subscribedTopics')
      .where('topicName', isEqualTo: topicName)
      .get()
      .then((value) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('subscribedTopics')
        .doc(value.docs.first.id)
        .delete();
  });
}

// void removeTopicToUser({
//   required String userID,
//   required String topicName,
// }) {
//   FirebaseFirestore.instance
//       .collection('users')
//       .doc(userID)
//       .collection('subscribedTopics')
//       .add({
//     'topicName': topicName,
//   });
// }
