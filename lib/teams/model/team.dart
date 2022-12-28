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
  String teamLeaderEmail;
  String teamLeaderName;
  String teamLeaderID;
  String deputyName;
  String mediaName;
  String econmicName;
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
    required this.teamLeaderID,
    required this.teamLeaderEmail,
    required this.teamLeaderName,
    required this.deputyName,
    required this.mediaName,
    required this.econmicName,
    required this.timestamp,
  });

  factory Team.fromDB(Map<String, dynamic> data, String id) {
    return Team(
      id: id,
      name: data['name'] ?? '',
      brief: data['brief'] ?? '',
      goals: data['goals'] ?? '',
      futurePlans: data['futurePlans'] ?? '',
      imageURL: data['imageURL'] ?? '',
      imagePath: data['imagePath'] ?? '',
      category: data['category'] ?? '',
      teamLeaderID: data['teamLeaderID'] ?? '',
      teamLeaderEmail: data['teamLeaderEmail'] ?? '',
      teamLeaderName: data['teamLeaderName'] ?? '',
      deputyName: data['deputyName'] ?? '',
      econmicName: data['econmicName'] ?? '',
      mediaName: data['mediaName'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
