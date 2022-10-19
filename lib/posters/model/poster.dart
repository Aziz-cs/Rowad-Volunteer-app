import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Poster {
  String id;
  String title;
  String posterURL;
  String imageURL;
  Timestamp timestamp;

  Poster({
    required this.id,
    required this.title,
    required this.posterURL,
    required this.imageURL,
    required this.timestamp,
  });

  factory Poster.fromDB(Map<String, dynamic> data, String id) {
    return Poster(
      id: id,
      title: data['title'] ?? '',
      posterURL: data['bannerURL'] ?? '',
      imageURL: data['imageURL'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
