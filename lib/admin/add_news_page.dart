import 'package:app/utils/constants.dart';
import 'package:app/widgets/dropdown_menu.dart';
import 'package:app/widgets/simple_btn.dart';
import 'package:app/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddNews extends StatelessWidget {
  AddNews({Key? key}) : super(key: key);

  final _titleController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _newsController = TextEditingController();
  final newsCategory = '- أختر -'.obs;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'عنوان الخبر',
                style: kTitleTextStyle,
              ),
              MyTextField(
                controller: _titleController,
                validator: (input) {},
              ),
              Text(
                'نبذة مختصرة',
                style: kTitleTextStyle,
              ),
              MyTextField(
                controller: _shortDescController,
                validator: (input) {},
              ),
              Text(
                'الخبر',
                style: kTitleTextStyle,
              ),
              MyTextField(
                inputAction: TextInputAction.newline,
                inputType: TextInputType.multiline,
                controller: _newsController,
                maxLines: 7,
                validator: (input) {},
              ),
              Text(
                'التصنيف',
                style: kTitleTextStyle,
              ),
              Obx(() => DropDownMenu(
                    value: newsCategory.value,
                    items: const [
                      '- أختر -',
                      'أخبار الجمعية',
                      'البرامج والمشاريع',
                      'التريب',
                      'أخرى'
                    ],
                    removeHeightPadding: true,
                    onChanged: (selectedCategory) {
                      newsCategory.value =
                          selectedCategory ?? newsCategory.value;
                    },
                  )),
              Text(
                'الصورة البارزة',
                style: kTitleTextStyle,
              ),
              SimpleButton(
                label: 'أختر الصورة',
                onPress: () async {
                  final ImagePicker _picker = ImagePicker();

                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                },
              ),
            ],
          ),
        ));
  }
}
