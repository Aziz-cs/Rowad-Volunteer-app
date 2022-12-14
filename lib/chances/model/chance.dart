import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../controller/chances_controller.dart';

class Chance {
  String id;
  String title;
  String shortDesc;
  String imageURL;
  String imagePath;
  String startDate;
  String endDate;
  String area;
  String city;
  String organization;
  String sitsNo;
  String category;
  String requiredDegree;
  String gender;
  bool isTeamWork;
  bool isUrgent;
  bool isOnline;
  bool isSupportDisabled;
  bool isNeedInterview;
  String chanceURL;
  Timestamp timestamp;

  Chance({
    required this.id,
    required this.title,
    required this.shortDesc,
    required this.imageURL,
    required this.imagePath,
    required this.startDate,
    required this.endDate,
    required this.area,
    required this.city,
    required this.organization,
    required this.sitsNo,
    required this.category,
    required this.requiredDegree,
    required this.gender,
    required this.isTeamWork,
    required this.isUrgent,
    required this.isOnline,
    required this.isSupportDisabled,
    required this.isNeedInterview,
    required this.chanceURL,
    required this.timestamp,
  });

  factory Chance.fromDB(Map<String, dynamic> data, String id) {
    return Chance(
      id: id,
      title: data['title'] ?? '',
      shortDesc: data['shortDesc'] ?? '',
      organization: data['organization'] ?? '',
      imageURL: data['imageURL'] ?? '',
      imagePath: data['imagePath'] ?? '',
      category: data['category'] ?? '',
      chanceURL: data['chanceURL'] ?? '',
      startDate: data['startDate'] ?? '',
      endDate: data['endDate'] ?? '',
      gender: data['gender'] ?? '',
      isNeedInterview: data['isNeedInterview'] ?? false,
      isOnline: data['isOnline'] ?? false,
      isSupportDisabled: data['isSupportDisabled'] ?? false,
      isTeamWork: data['isTeamWork'] ?? false,
      isUrgent: data['isUrgent'] ?? false,
      area: data['area'] ?? '',
      city: data['city'] ?? '',
      requiredDegree: data['requiredDegree'] ?? '',
      sitsNo: data['sitsNo'] ?? 0,
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  int getDaysLeft() {
    var formatter = DateFormat('dd-MM-yyyy');
    DateTime startDateTime = formatter.parse(startDate);
    DateTime endDateTime = formatter.parse(endDate);
    return endDateTime.difference(startDateTime).inDays;
  }

  String getDaysWordinArabic() {
    if (getDaysLeft() == 1) return '??????';
    if (getDaysLeft() < 11) return '????????';

    return '??????';
  }
}
