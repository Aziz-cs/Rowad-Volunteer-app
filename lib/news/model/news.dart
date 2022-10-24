import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class News {
  String id;
  String title;
  String subTitle;
  String description;
  String category;
  String imageURL;
  String imagePath;
  Timestamp timestamp;

  News({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.category,
    required this.imageURL,
    required this.imagePath,
    required this.timestamp,
  });

  factory News.fromDB(Map<String, dynamic> data, String id) {
    return News(
      id: id,
      title: data['title'] ?? '',
      subTitle: data['subTitle'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      imageURL: data['imageURL'] ?? '',
      imagePath: data['imagePath'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
