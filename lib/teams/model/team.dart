import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  String id;
  String name;
  String brief;
  String goals;
  String futurePlans;
  String category;
  String imageURL;
  String imagePath;
  String teamLeaderUID;
  String deputyUID;
  String mediaUID;
  String econmicUID;
  Timestamp timestamp;

  Team({
    required this.id,
    required this.name,
    required this.brief,
    required this.goals,
    required this.futurePlans,
    required this.category,
    required this.imageURL,
    required this.imagePath,
    required this.teamLeaderUID,
    required this.deputyUID,
    required this.mediaUID,
    required this.econmicUID,
    required this.timestamp,
  });

  factory Team.fromDB(Map<String, dynamic> data, String id) {
    return Team(
      id: id,
      name: data['name'] ?? '',
      brief: data['brief'] ?? '',
      goals: data['gaols'] ?? '',
      futurePlans: data['futurePlans'] ?? '',
      imageURL: data['imageURL'] ?? '',
      imagePath: data['imagePath'] ?? '',
      category: data['category'] ?? '',
      teamLeaderUID: data['teamLeaderUID'],
      deputyUID: data['dupterUID'],
      econmicUID: data['econmicUID'],
      mediaUID: data['mediaUID'],
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
