import 'dart:io';

import 'package:app/news/controller/news_controller.dart';
import 'package:app/news/model/news.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../general/controller/image_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/circular_loading.dart';
import '../../widgets/dropdown_menu.dart';
import '../../widgets/simple_btn.dart';
import '../../widgets/textfield.dart';

const String kChooseCategory = '- أختر -';

class AddNewsPage extends StatelessWidget {
  AddNewsPage({Key? key}) : super(key: key);

  final newsController = Get.put(NewsController());
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _subTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final newsCategory = '- أختر -'.obs;

  // late final XFile? pickedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kGreenColor,
          title: const Text('إضافة خبر'),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'عنوان الخبر',
                    style: kTitleTextStyle,
                  ),
                  MyTextField(
                    controller: _titleController,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return kErrEmpty;
                      }
                    },
                  ),
                  Text(
                    'نبذة مختصرة',
                    style: kTitleTextStyle,
                  ),
                  MyTextField(
                    controller: _subTitleController,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return kErrEmpty;
                      }
                    },
                  ),
                  Text(
                    'الخبر',
                    style: kTitleTextStyle,
                  ),
                  MyTextField(
                    inputAction: TextInputAction.newline,
                    inputType: TextInputType.multiline,
                    controller: _descriptionController,
                    maxLines: 7,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return kErrEmpty;
                      }
                    },
                  ),
                  Text(
                    'التصنيف',
                    style: kTitleTextStyle,
                  ),
                  FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('news_categories')
                          .orderBy('name')
                          .get(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          List<String> categoriesList = [];
                          var result = snapshot.data!.docs;
                          result.forEach((element) {
                            Map category = element.data() as Map;
                            categoriesList.add(category['name']);
                          });
                          return Obx(() => DropDownMenu(
                                value: newsCategory.value,
                                items: categoriesList.toList(),
                                removeHeightPadding: true,
                                onChanged: (selectedCategory) {
                                  newsCategory.value =
                                      selectedCategory ?? newsCategory.value;
                                },
                              ));
                        }
                        return const Center(child: CircularLoading());
                      })),
                  Text(
                    'الصورة البارزة',
                    style: kTitleTextStyle,
                  ),
                  SimpleButton(
                      label: 'أختر الصورة',
                      onPress: () async {
                        newsController.pickedImage.value =
                            await ImageController.pickImage();
                      }),
                  Obx(
                    () => newsController.pickedImage.value.path.isEmpty
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.file(
                                File(newsController.pickedImage.value.path),
                                width: 250.w,
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: 10.h),
                  Obx(() => newsController.isLoading.isTrue
                      ? const Center(child: CircularLoading())
                      : SimpleButton(
                          label: 'إضافة الخبر',
                          onPress: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            if (newsController.pickedImage.value.path.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'برجاء رفع صورة للخبر');
                              return;
                            }
                            if (newsCategory.value == kChooseCategory) {
                              Fluttertoast.showToast(
                                  msg: 'برجاء إختيار التصنيف');
                              return;
                            }

                            News news = News(
                              id: '',
                              title: _titleController.text.trim(),
                              subTitle: _subTitleController.text.trim(),
                              description: _descriptionController.text.trim(),
                              category: newsCategory.value,
                              imageURL: '',
                              imagePath: '',
                              timestamp: Timestamp.now(),
                            );

                            newsController.addModifyNews(news: news);
                          },
                        )),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ));
  }

  // void resetProperties() {
  //   _titleController.clear();
  //   _shortDescController.clear();
  //   _longDescController.clear();
  //   newsController.pickedImage.value = File('');
  //   newsCategory.value = kChooseCategory;
  // }
}
