import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class News {
  String id;
  String title;
  String subTitle;
  String description;
  String imageURL;
  Timestamp timestamp;

  News({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.imageURL,
    required this.timestamp,
  });

  factory News.fromDB(Map<String, dynamic> data, String id) {
    return News(
      id: id,
      title: data['title'] ?? '',
      subTitle: data['subTitle'] ?? '',
      description: data['description'] ?? '',
      imageURL: data['imageURL'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  String getFormatedDate() {
    var dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    var formattedDate = DateFormat('MM/dd/yyyy').format(dateTime);
    return formattedDate;
  }
}
