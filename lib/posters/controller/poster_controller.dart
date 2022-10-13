import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/poster.dart';

class PosterController extends GetxController {
  List<Poster> posters = [];
  final isLoading = false.obs;
  final pickedImage = File('').obs;
  final ImagePicker picker = ImagePicker();

  Poster poster = Poster(
      id: '',
      title: 'title',
      posterURL: 'posterURL',
      imageURL: 'imageURL',
      timestamp: Timestamp.now());
  Future<void> addBanner({
    required String title,
    required String bannerURL,
  }) async {
    FirebaseFirestore.instance.collection('posters').add({
      'title': 'توصيل المياة لـ ١٠٠ أسرة فى الدمام',
      'imageURL':
          'https://www.islamicreliefcanada.org/wp-content/uploads/2022/04/RS260227_IMG_8669-1-scaled.jpg',
      'timestamp': Timestamp.now(),
      'bannerURL': 'https://nvg.gov.sa/',
    });
  }

  Future<void> pickImage() async {
    try {
      final XFile? imageFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 17,
      );
      pickedImage.value = File(imageFile!.path);
    } catch (e) {
      print('error in image picking $e');
    }
  }
}
