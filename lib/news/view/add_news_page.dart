import 'dart:io';

import 'package:app/news/controller/news_controller.dart';
import 'package:app/news/model/news.dart';
import 'package:app/widgets/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

class AddNewsPage extends StatelessWidget {
  AddNewsPage({Key? key}) : super(key: key);
  final newsController = Get.put(NewsController());
  final _addCategoryController = TextEditingController();
  final _isLoading = false.obs;

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  // final _subTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final newsCategory = '- اختر -'.obs;

  // late final XFile? pickedImage;
  @override
  Widget build(BuildContext context) {
    clearProperties();
    return Scaffold(
        appBar: MyAppBar(title: 'اضافة خبر'),
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
                    'الخبر',
                    style: kTitleTextStyle,
                  ),
                  MyTextField(
                    inputAction: TextInputAction.newline,
                    inputType: TextInputType.multiline,
                    controller: _descriptionController,
                    maxLines: 7,
                    validator: (input) {
                      // if (input!.isEmpty) {
                      //   return kErrEmpty;
                      // }
                    },
                  ),
                  Text(
                    'التصنيف',
                    style: kTitleTextStyle,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('news_categories')
                                .orderBy('name')
                                .snapshots(),
                            builder: ((context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
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
                                      onChanged: (selectedValue) {
                                        newsCategory.value =
                                            selectedValue ?? newsCategory.value;
                                      },
                                    ));
                              }
                              return Center(child: CircularLoading());
                            })),
                      ),
                      // SimpleButton(
                      //   label: 'اضف تصنيفا',
                      //   onPress: () {}
                      // ),
                    ],
                  ),
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
                  Text(
                    'ألبوم الصور (إختياري)',
                    style: kTitleTextStyle,
                  ),
                  Obx(() => Visibility(
                        visible: newsController.photoAlbum.length < 3,
                        child: SimpleButton(
                            label: 'أضف صورة',
                            onPress: () async {
                              File pickedImage =
                                  await ImageController.pickImage();
                              if (pickedImage.path.isNotEmpty) {
                                newsController.photoAlbum.add(pickedImage);
                              }

                              // newsController.pickedImage.value =
                              //     await ImageController.pickImage();
                            }),
                      )),
                  Obx(
                    () => Row(
                      children: newsController.photoAlbum
                          .map(
                            (e) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              child: Stack(
                                children: [
                                  Image.file(
                                    File((e as File).path),
                                    width: 100.w,
                                    height: 100.h,
                                    fit: BoxFit.fill,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(
                                        CupertinoIcons.xmark,
                                        color: Colors.red,
                                        size: 16,
                                      ),
                                      onPressed: () {
                                        print('pressed');
                                        newsController.photoAlbum.removeWhere(
                                            (imageFile) =>
                                                (imageFile as File).path ==
                                                e.path);
                                        Fluttertoast.showToast(
                                          msg: 'تم إزالة الصورة',
                                          toastLength: Toast.LENGTH_SHORT,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    //  Column(
                    //   children: newsController.photoAlbum
                    //       .map((e) => Text(
                    //             textDirection: TextDirection.ltr,
                    //             (e as File).path,
                    //           ))
                    //       .toList(),
                    // ),
                  ),
                  Obx(() => newsController.isLoading.isTrue
                      ? Center(child: CircularLoading())
                      : SimpleButton(
                          label: 'إضافة الخبر',
                          onPress: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            // if (newsController.pickedImage.value.path.isEmpty) {
                            //   Fluttertoast.showToast(
                            //       msg: 'برجاء رفع صورة للخبر');
                            //   return;
                            // }
                            if (newsCategory.value == kChoose) {
                              Fluttertoast.showToast(
                                  msg: 'برجاء إختيار التصنيف');
                              return;
                            }

                            News news = News(
                              id: '',
                              title: _titleController.text.trim(),
                              // subTitle: _subTitleController.text.trim(),
                              description: _descriptionController.text.trim(),
                              category: newsCategory.value,
                              imageURL:
                                  newsController.pickedImage.value.path.isEmpty
                                      ? kDefaultImgURL
                                      : '',
                              imagePath: '',
                              gallery: newsController.photoAlbum,
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

  void clearProperties() {
    newsController.photoAlbum.clear();
    newsController.pickedImage.value = File('');
  }
}
