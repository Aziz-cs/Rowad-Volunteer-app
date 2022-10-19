import 'package:app/news/view/add_news_page.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:app/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants.dart';

class AdminPanelPage extends StatelessWidget {
  AdminPanelPage({Key? key}) : super(key: key);
  final _addCategoryController = TextEditingController();
  final _isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenColor,
        title: const Text('لوحة التحكم'),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.newspaper),
              title: const Text('المركز الإعلامي'),
              subtitle: const Text('اضف تصنيف'),
              trailing: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
              ),
              onTap: () => Get.defaultDialog(
                title: 'اضافة تصنيف',
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('news_categories')
                              .orderBy('name')
                              .snapshots(),
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              var result = snapshot.data!.docs;
                              return Column(
                                children: List.generate(
                                  result.length,
                                  (index) => result[index]['name'] ==
                                          kChooseCategory
                                      ? const SizedBox()
                                      : ListTile(
                                          title: Text(result[index]['name']),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              CupertinoIcons.xmark,
                                              size: 18,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('news_categories')
                                                  .doc(result[index].id)
                                                  .delete();
                                            },
                                          ),
                                        ),
                                ),
                              );
                              // result.forEach((element) {
                              //   print(element.data());
                              //   Map category = element.data() as Map;
                              //   categoriesList.add(category['name']);
                              // });
                            }
                            return const Center(child: CircularLoading());
                          })),
                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                                label: 'التصنيف الجديد',
                                controller: _addCategoryController,
                                validator: (input) {}),
                          ),
                          Obx(() => _isLoading.isTrue
                              ? const CircularLoading()
                              : IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.add_circled_solid,
                                    color: kGreenColor,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    print('pressed');
                                    if (_addCategoryController.text
                                        .trim()
                                        .isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: 'برجاء كتابة التصنيف');
                                      return;
                                    }
                                    _isLoading.value = true;
                                    await FirebaseFirestore.instance
                                        .collection('news_categories')
                                        .add({
                                      'name':
                                          _addCategoryController.text.trim(),
                                    });
                                    _isLoading.value = false;
                                    _addCategoryController.clear();
                                  },
                                ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 4.h,
            ),
          ],
        ),
      ),
    );
  }
}
