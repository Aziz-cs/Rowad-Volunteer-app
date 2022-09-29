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
