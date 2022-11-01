import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  String id;
  String name;
  String intro;
  String details;
  String owner;
  String instructorName;
  String startDate;
  String duration;
  String imageURL;
  String imagePath;
  String registerationURL;
  bool isRegisterationOpen;
  Timestamp timestamp;

  Course({
    required this.id,
    required this.name,
    required this.intro,
    required this.details,
    required this.owner,
    required this.instructorName,
    required this.startDate,
    required this.duration,
    required this.imageURL,
    required this.imagePath,
    required this.registerationURL,
    required this.isRegisterationOpen,
    required this.timestamp,
  });

  factory Course.fromDB(Map<String, dynamic> data, String id) {
    return Course(
      id: id,
      name: data['name'] ?? '',
      intro: data['intro'] ?? '',
      details: data['details'] ?? '',
      owner: data['owner'] ?? '',
      instructorName: data['instructorName'] ?? '',
      startDate: data['startDate'] ?? '',
      duration: data['duration'] ?? '',
      imageURL: data['imageURL'] ?? '',
      imagePath: data['imagePath'] ?? '',
      registerationURL: data['registerationURL'] ?? '',
      isRegisterationOpen: data['isRegisterationOpen'] ?? true,
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
