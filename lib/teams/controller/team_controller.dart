import 'dart:io';

import 'package:app/general/model/image.dart';
import 'package:app/notifications/controller/notification_controller.dart';
import 'package:app/profile/controller/profile_controller.dart';
import 'package:app/profile/model/volunteer.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/sharedprefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../general/controller/image_controller.dart';
import '../../widgets/navigator_page.dart';
import '../model/team.dart';

class TeamController extends GetxController {
  final isLoading = false.obs;
  final pickedImage = File('').obs;
  final ImagePicker picker = ImagePicker();
  var isDeleteLoading = false.obs;

  final isCheckingEmail = false.obs;
  final isTeamLeaderEmailValid = false.obs;

  String teamLeaderEmail = '';
  String teamLeaderName = '';
  String teamLeaderID = '';

  final isLoadingAskToJoin = false.obs;
  final isLoadingTeamDecision = false.obs;
  final isLoadingSendingNotification = false.obs;
  Future<void> addModifyTeam({
    required Team team,
    bool isModifing = false,
    bool isPicChanged = false,
    bool isTeamLeaderChanged = false,
  }) async {
    isLoading.value = true;

    Map<String, dynamic> teamData = {
      'name': team.name,
      'brief': team.brief,
      'goals': team.goals,
      'category': team.category,
      'futurePlans': team.futurePlans,
      'teamLeaderEmail': team.teamLeaderEmail,
      'teamLeaderName': team.teamLeaderName,
      'teamLeaderID': team.teamLeaderID,
      'deputyName': team.deputyName,
      'econmicName': team.econmicName,
      'mediaName': team.mediaName,
      'timestamp': isModifing ? team.timestamp : FieldValue.serverTimestamp(),
      'imageURL': team.imageURL,
      'imagePath': team.imagePath,
    };

    if (isModifing) {
      await FirebaseFirestore.instance
          .collection('teams')
          .doc(team.id)
          .update(teamData)
          .catchError((e) {
        print('error on submitting the news $e');
        isLoading.value = false;
      });

      if (isPicChanged) {
        UploadedImage uploadedImage = await ImageController.uploadImage(
          imageFile: pickedImage.value,
          category: 'teams',
          docID: team.id,
        );

        await FirebaseFirestore.instance
            .collection('team')
            .doc(team.id)
            .update({
          'imageURL': uploadedImage.imageURL,
          'imagePath': uploadedImage.imagePath,
        });
      }

      isLoading.value = false;
      print('is changed mail: $isTeamLeaderChanged');
      if (isTeamLeaderChanged) {
        updateUserTypeToTeamLeader(
          teamLeaderID: teamLeaderID,
          teamID: team.id,
        );
      }

      Fluttertoast.showToast(msg: 'تم تعديل الفريق بنجاح');
      Get.offAll(
        () => NavigatorPage(),
        duration: const Duration(microseconds: 1),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('teams')
          .add(teamData)
          .then((doc) async {
        if (pickedImage.value.path.isNotEmpty) {
          UploadedImage uploadedImage = await ImageController.uploadImage(
            imageFile: pickedImage.value,
            category: 'teams',
            docID: doc.id,
          );
          await FirebaseFirestore.instance
              .collection('teams')
              .doc(doc.id)
              .update({
            'imageURL': uploadedImage.imageURL,
            'imagePath': uploadedImage.imagePath,
          });
        }

        print('DOC ID: ${doc.id}');
        updateUserTypeToTeamLeader(
          teamLeaderID: teamLeaderID,
          teamID: doc.id,
        ).then((value) {
          if (teamLeaderID.isNotEmpty) {
            FirebaseFirestore.instance
                .collection('teams')
                .doc(doc.id)
                .collection('teamMembers')
                .doc(teamLeaderID)
                .set({
              'timestamp': FieldValue.serverTimestamp(),
              'email': teamLeaderEmail,
              'uID': teamLeaderID,
            });
          }
        });

        isLoading.value = false;
        Fluttertoast.showToast(msg: 'تم إضافة الفريق بنجاح');
        Get.offAll(
          () => NavigatorPage(),
          duration: const Duration(microseconds: 1),
        );
      }).catchError((e) {
        print('error on submitting the news $e');
        isLoading.value = false;
      });
    }
  }

  Future<void> deleteTeam(Team team) async {
    isDeleteLoading.value = true;

    await FirebaseFirestore.instance.collection('teams').doc(team.id).delete();

    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: team.teamLeaderEmail.toLowerCase())
        .get()
        .then((result) {
      teamLeaderID = result.docs.first.id;
      FirebaseFirestore.instance.collection('users').doc(teamLeaderID).update({
        'userRole': kVolunteer,
      }).catchError(
          (e) => print('Could not update user Role to Team Leader $e'));

      sendPushNotification(
          title: 'جمعية رواد',
          body: 'تم حذف فريق ${team.name}',
          topicName: result.docs.first.id);
    });

    if (team.imagePath.isNotEmpty) {
      await FirebaseStorage.instance
          .ref()
          .child(team.imagePath)
          .delete()
          .catchError((e) {
        print('error main image is not deleted $e');
        Get.offAll(
          () => NavigatorPage(),
          duration: const Duration(microseconds: 1),
        );
        isDeleteLoading.value = false;
      });
    }
    Fluttertoast.showToast(msg: 'تم حذف الفريق');
    Get.offAll(
      () => NavigatorPage(),
      duration: const Duration(microseconds: 1),
    );

    isDeleteLoading.value = false;
  }

  Future<void> checkTeamLeaderEmailValid(String email) async {
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: 'برجاء كتابة بريد قائد الفريق');
      return;
    }
    if (!GetUtils.isEmail(email)) {
      Fluttertoast.showToast(msg: 'برجاء كتابة بريد القائد بشكل صحيح');
      return;
    }
    print('checking..');
    isCheckingEmail.value = true;
    var result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email.toLowerCase())
        .get();
    isCheckingEmail.value = false;
    if (result.docs.isNotEmpty) {
      isTeamLeaderEmailValid.value = true;
      teamLeaderEmail = email;
      teamLeaderName = result.docs.first['name'];
      teamLeaderID = result.docs.first.id;
      isTeamLeaderEmailValid.value = true;
    } else {
      Fluttertoast.showToast(msg: 'هذا البريد ليس موجود');
      return;
    }
  }

  Future<void> updateUserTypeToTeamLeader({
    required String teamLeaderID,
    required String teamID,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(teamLeaderID)
        .update({'userRole': kTeamLeader}).catchError((e) {});
    print('DOC ID inside: $teamID');

    subscribeUserToTopic(userID: teamLeaderID, topicName: teamID);

    print('user $teamLeaderID has been pormoted to Team Leader!');
    sendPushNotification(
        title: 'جمعية رواد',
        body: 'تهانينا! تم تعينك قائد فريق',
        topicName: teamLeaderID);
  }

  Future<void> removeTeamLeader(
      {required String email, required String teamID}) async {
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email.toLowerCase())
        .get()
        .then((result) {
      var userID = result.docs.first.id;
      unSubscribeUserFromTopic(userID: userID, topicName: teamID);

      FirebaseFirestore.instance.collection('users').doc(userID).update({
        'userRole': kVolunteer,
      }).catchError((e) =>
          print('Could not update user Role from Leader to Volunteer $e'));
    }).catchError(
            (e) => print('Could not find Email address of Team Leader $e'));
  }

  void askToJoinTeam(Team team) {
    isLoadingAskToJoin.value = true;

    FirebaseFirestore.instance
        .collection('teams')
        .doc(team.id)
        .collection('pendingMembers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'timestamp': FieldValue.serverTimestamp(),
      'email': teamLeaderEmail,
      'uID': FirebaseAuth.instance.currentUser!.uid,
    }).then((value) {
      Fluttertoast.showToast(msg: 'تم إرسال الطلب بنجاح');
      isLoadingAskToJoin.value = false;
      sendPushNotification(
        title: 'رواد | طلب انضمام لـ "${team.name}"',
        body: FirebaseAuth.instance.currentUser?.email ?? '',
        topicName: team.teamLeaderID,
      );
      sendInternalNotification(
        title: 'طلب انضمام لـ "${team.name}"',
        body: FirebaseAuth.instance.currentUser?.email ?? '',
        targetTopics: [
          team.teamLeaderID,
        ],
      );
    }).catchError((e) {
      Fluttertoast.showToast(msg: kErrSomethingWrong);
      print('error joing team $e');
      isLoadingAskToJoin.value = false;
    });
  }

  void acceptPendingMember({
    required Team team,
    required Volunteer volunteer,
  }) {
    isLoadingTeamDecision.value = true;
    FirebaseFirestore.instance
        .collection('teams')
        .doc(team.id)
        .collection('teamMembers')
        .doc(volunteer.id)
        .set({
      'uID': volunteer.id,
      'email': volunteer.email,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      FirebaseFirestore.instance
          .collection('teams')
          .doc(team.id)
          .collection('pendingMembers')
          .doc(volunteer.id)
          .delete();

      subscribeUserToTopic(userID: volunteer.id, topicName: team.id);
      sendPushNotification(
          title: 'رواد | فريق ${team.name}',
          body: 'تهانينا! تم قبول طلبك',
          topicName: volunteer.id);
      Fluttertoast.showToast(msg: 'تم قبول المتطوع وإشعاره بذلك');
      isLoadingTeamDecision.value = false;
    });
  }

  Future<void> refusePendingMember({
    required Team team,
    required Volunteer volunteer,
  }) async {
    isLoadingTeamDecision.value = true;
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(team.id)
        .collection('pendingMembers')
        .doc(volunteer.id)
        .delete();
    Fluttertoast.showToast(msg: 'تم رفض الطلب');
    isLoadingTeamDecision.value = false;
  }

  // Future<void> sendTeamNotification({
  //   required String title,
  //   required String body,
  //   required Team team,
  // }) async {
  //   sendPushNotification(title: title, body: body, topicName: team.id);
  // }

}
