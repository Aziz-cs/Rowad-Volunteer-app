import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Poster {
  String id;
  String title;
  String posterURL;
  String imageURL;
  String imagePath;
  Timestamp timestamp;

  Poster({
    required this.id,
    required this.title,
    required this.posterURL,
    required this.imageURL,
    required this.imagePath,
    required this.timestamp,
  });

  factory Poster.fromDB(Map<String, dynamic> data, String id) {
    return Poster(
      id: id,
      title: data['title'] ?? '',
      posterURL: data['posterURL'] ?? '',
      imageURL: data['imageURL'] ?? '',
      imagePath: data['imagePath'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
