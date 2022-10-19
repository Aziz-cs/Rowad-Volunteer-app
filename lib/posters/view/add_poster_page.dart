import 'dart:io';

import 'package:app/controller/image_controller.dart';
import 'package:app/posters/controller/poster_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../../widgets/circular_loading.dart';
import '../../widgets/simple_btn.dart';
import '../../widgets/textfield.dart';

class AddPoster extends StatelessWidget {
  AddPoster({Key? key}) : super(key: key);

  final posterController = Get.put(PosterController());
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _posterURLController = TextEditingController();

  // late final XFile? pickedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kGreenColor,
          title: const Text('إضافة إعلان'),
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
                    'العنوان',
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
                    'الرابط',
                    style: kTitleTextStyle,
                  ),
                  MyTextField(
                    controller: _posterURLController,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return kErrEmpty;
                      }
                    },
                  ),
                  Text(
                    'الصورة',
                    style: kTitleTextStyle,
                  ),
                  SimpleButton(
                    label: 'أختر الصورة',
                    onPress: () async {
                      posterController.pickedImage.value =
                          await ImageController.pickImage(imageQuality: 25);
                    },
                  ),
                  Obx(
                    () => posterController.pickedImage.value.path.isEmpty
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.file(
                                File(posterController.pickedImage.value.path),
                                width: 250.w,
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: 10.h),
                  Obx(() => posterController.isLoading.isTrue
                      ? const Center(child: CircularLoading())
                      : SimpleButton(
                          label: 'إضافة الإعلان',
                          onPress: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            if (_posterURLController.text.trim().isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'برجاء إضافة رابط للإعلان');
                              return;
                            }
                            if (posterController
                                .pickedImage.value.path.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'برجاء رفع صورة للإعلان');
                              return;
                            }

                            posterController.addPoster(
                              title: _titleController.text.trim(),
                              posterURL: _posterURLController.text.trim(),
                            );
                          },
                        )),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ));
  }
}
