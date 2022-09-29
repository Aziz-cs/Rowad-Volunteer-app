class News {
  String id;
  String title;
  String subTitle;
  String details;
  String imageURL;

  News({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.details,
    required this.imageURL,
  });

  factory News.fromRTDB(Map<dynamic, dynamic> data, String id) {
    return News(
      id: id,
      title: data['title'] ?? '',
      subTitle: data['subTitle'] ?? '',
      details: data['details'] ?? '',
      imageURL: data['imageURL'] ?? '',
    );
  }
}
