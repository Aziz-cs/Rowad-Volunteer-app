import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GlobalNotification {
  String title;
  String body;
  List targetTopics;
  Timestamp timestamp;

  GlobalNotification({
    required this.title,
    required this.body,
    required this.targetTopics,
    required this.timestamp,
  });

  factory GlobalNotification.fromDB(Map<String, dynamic> data, String id) {
    return GlobalNotification(
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      targetTopics: data['targetTopics'] ?? [],
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  String getDate() {
    return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
  }

  String getTime() {
    return DateFormat('HH:mm').format(timestamp.toDate());
  }
}
