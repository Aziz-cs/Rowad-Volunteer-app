import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class NewsController extends GetxController {
  final isLoading = false.obs;
  final pickedImage = File('').obs;
  final ImagePicker picker = ImagePicker();

  Future<void> addNews({
    required String title,
    required String shortDesc,
    required String description,
    required String category,
  }) async {
    isLoading.value = true;
    String imageURL = await uploadImage(imageFile: pickedImage.value);
    await FirebaseFirestore.instance.collection('news').doc().set(
      {
        'title': title,
        'subTitle': shortDesc,
        'description': description,
        'category': category,
        'timestamp': FieldValue.serverTimestamp(),
        'imageURL': imageURL,
      },
    ).then((value) {
      isLoading.value = false;
    }).catchError((e) {
      print('error on submitting the news $e');
      isLoading.value = false;
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

  Future<String> uploadImage({required File imageFile}) async {
    String imageExtenstion = path.extension(imageFile.path);
    final ref = FirebaseStorage.instance.ref().child('images').child('news').child(
        '${Timestamp.now().millisecondsSinceEpoch.toString()}$imageExtenstion');

    await ref.putFile(imageFile);
    String downloadURL = await ref.getDownloadURL();
    print('download: $downloadURL');
    return downloadURL;
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