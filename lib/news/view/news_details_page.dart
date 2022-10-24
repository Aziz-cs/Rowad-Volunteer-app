import 'package:app/news/view/edit_news_page.dart';
import 'package:app/widgets/navigator_page.dart';
import 'package:app/widgets/simple_btn.dart';
import 'package:app/widgets/textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../../utils/helper.dart';
import '../../widgets/back_btn.dart';
import '../../widgets/circular_loading.dart';
import '../../widgets/dropdown_menu.dart';
import '../model/news.dart';

const String opportunityDetails = 'هذا النص الذي يعطي نبذة عن الفرصة التطوعية ';

class NewsDetailsPage extends StatelessWidget {
  NewsDetailsPage({
    Key? key,
    required this.news,
  }) : super(key: key);
  News news;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
        appBar: AppBar(toolbarHeight: 0),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOpportunityHeadbar(context),
              SizedBox(height: 10.h),
              _buildOppertunityDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOppertunityDetails() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: Column(
            children: [
              Text(
                news.description,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Stack _buildOpportunityHeadbar(BuildContext context) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: news.imageURL,
          fit: BoxFit.fill,
          height: 210.h,
          width: double.infinity,
          placeholder: (context, url) => Padding(
            padding: const EdgeInsets.all(30.0),
            child: Image.asset('assets/images/loading_spinner.gif'),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.error,
            color: kGreenColor,
          ),
        ),
        Container(
          height: 210.h,
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: FractionalOffset.centerLeft,
                end: FractionalOffset.centerRight,
                colors: [
                  Colors.grey.withOpacity(0.0),
                  Colors.black.withOpacity(0.65),
                ],
                stops: const [
                  0.0,
                  0.7,
                ],
              )),
        ),
        Positioned(
            top: 4.h,
            left: 4.w,
            child: IconButton(
              onPressed: () {
                Get.to(() => EditNewsPage(news: news));
                // Get.defaultDialog(
                //   title: 'تعديل الخبر',
                //   content: EditNewsDialog(news: widget.news),
                // ).then((value) {
                //   setState(() {});
                // });
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            )),
        Positioned(
          bottom: 2.h,
          left: 2.w,
          child: Text(
            getFormatedDate(news.timestamp),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          right: 5.w,
          child: const BackBtn(),
        ),
        Positioned(
          bottom: 30.h,
          right: 5.w,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              width: 0.85.sw,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: TextStyle(
                      height: 1,
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    news.subTitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      height: 1,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class EditNewsDialog extends StatelessWidget {
//   EditNewsDialog({
//     Key? key,
//     required this.news,
//   }) : super(key: key);

//   News news;
//   final _titleController = TextEditingController();
//   final _subTitleController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     _titleController.text = news.title;
//     _subTitleController.text = news.subTitle;
//     _descriptionController.text = news.description;
//     final newsCategory = news.category.obs;
//     var _isLoading = false.obs;
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'عنوان الخبر',
//             style: kTitleTextStyle,
//           ),
//           MyTextField(
//             controller: _titleController,
//             maxLines: 2,
//             validator: (input) {
//               if (input!.isEmpty) {
//                 return kErrEmpty;
//               }
//             },
//           ),
//           Text(
//             'نبذة مختصرة',
//             style: kTitleTextStyle,
//           ),
//           MyTextField(
//             maxLines: 2,
//             controller: _subTitleController,
//             validator: (input) {
//               if (input!.isEmpty) {
//                 return kErrEmpty;
//               }
//             },
//           ),
//           Text(
//             'الخبر',
//             style: kTitleTextStyle,
//           ),
//           MyTextField(
//             inputAction: TextInputAction.newline,
//             inputType: TextInputType.multiline,
//             controller: _descriptionController,
//             maxLines: 7,
//             validator: (input) {
//               if (input!.isEmpty) {
//                 return kErrEmpty;
//               }
//             },
//           ),
//           Text(
//             'التصنيف',
//             style: kTitleTextStyle,
//           ),
//           FutureBuilder<QuerySnapshot>(
//               future: FirebaseFirestore.instance
//                   .collection('news_categories')
//                   .orderBy('name')
//                   .get(),
//               builder: ((context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   List<String> categoriesList = [];
//                   var result = snapshot.data!.docs;
//                   result.forEach((element) {
//                     Map category = element.data() as Map;
//                     categoriesList.add(category['name']);
//                   });
//                   return Obx(() => DropDownMenu(
//                         value: newsCategory.value,
//                         items: categoriesList.toList(),
//                         removeHeightPadding: true,
//                         onChanged: (selectedCategory) {
//                           newsCategory.value =
//                               selectedCategory ?? newsCategory.value;
//                         },
//                       ));
//                 }
//                 return const Center(child: CircularLoading());
//               })),
//           SizedBox(height: 10.h),
//           Obx(() => _isLoading.isTrue
//               ? const Center(child: CircularLoading())
//               : Column(
//                   children: [
//                     SimpleButton(
//                         label: 'تعديل',
//                         onPress: () async {
//                           _isLoading.value = true;

//                           await FirebaseFirestore.instance
//                               .collection('news')
//                               .doc(news.id)
//                               .update({
//                             'title': _titleController.text.trim(),
//                             'subTitle': _subTitleController.text.trim(),
//                             'description': _descriptionController.text.trim(),
//                           }).then((value) {
//                             news.title = _titleController.text.trim();
//                             news.subTitle = _subTitleController.text.trim();
//                             news.description =
//                                 _descriptionController.text.trim();
//                             Fluttertoast.showToast(msg: 'تم التعديل بنجاح');
//                             Get.back();
//                             // Get.offAll(() => NavigatorPage(tabIndex: 2));
//                           }).catchError((e) {
//                             Fluttertoast.showToast(msg: kErrSomethingWrong);
//                             print('error on modifying $e');
//                           });
//                           _isLoading.value = false;
//                         }),
//                     SimpleButton(
//                         label: 'حذف',
//                         onPress: () async {
//                           print('imagepath: ${news.imagePath}');
//                           _isLoading.value = true;
//                           await FirebaseFirestore.instance
//                               .collection('news')
//                               .doc(news.id)
//                               .delete();
//                           await FirebaseStorage.instance
//                               .ref()
//                               .child(news.imagePath)
//                               .delete();
//                           Fluttertoast.showToast(msg: 'تم حذف الخبر');
//                           Get.offAll(
//                               () => NavigatorPage(
//                                     tabIndex: 2,
//                                   ),
//                               duration: const Duration(microseconds: 1));
//                           _isLoading.value = false;
//                         }),
//                     SimpleButton(
//                         label: 'إلغاء', onPress: () => Navigator.pop(context)),
//                   ],
//                 )),
//         ],
//       ),
//     );
//   }
// }
