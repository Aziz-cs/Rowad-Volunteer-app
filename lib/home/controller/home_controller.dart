import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomeController extends GetxController {
  String news = '';

  void getNews() {
    FirebaseFirestore.instance.collection('news').get().then((value) {
      print(value.docs.first);
    });
  }
}
