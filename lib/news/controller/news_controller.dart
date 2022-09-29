import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NewsController extends GetxController {
  void addNews() {
    FirebaseFirestore.instance.collection('news').doc().set(
      {
        'title': '',
        'imageURL': '',
        'shortDesc': '',
        'category': '',
        'description': '',
        'timestamp': '',
        'imageURL': '',
      },
    );
  }
}

  // FirebaseFirestore.instance.collection('news').get().then((value) {
  //   print(value.docs.first.data());
  // });

  // await FirebaseFirestore.instance.collection('news').get().then((snapshot) {
  //   snapshot.docs.forEach((element) {
  //     News news = News.fromRTDB(element.data(), element.id);
  //     allNews.add(news);
  //   });
  //   allNews.forEach(
  //     (element) {
  //       print('Title: ${element.title}');
  //       print('SubTitle: ${element.subTitle}');
  //       print('Details: ${element.details}');
  //       print('ID: ${element.id}');
  //       print('=======');
  //     },
  //   );
  // });