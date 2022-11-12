import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../../widgets/circular_loading.dart';

const String kAllNewsCategory = 'جميع الأخبار';

class NewsFilterBar extends StatelessWidget {
  NewsFilterBar({
    Key? key,
    required this.selectedNewsCategory,
  }) : super(key: key);

  RxString selectedNewsCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: Row(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('news_categories')
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  print(snapshot.connectionState.toString());
                  List newsCategoriesList = [kAllNewsCategory];
                  var newsCategoriesResult = snapshot.data!.docs;
                  newsCategoriesResult.forEach((element) {
                    newsCategoriesList.add(element['name']);
                  });
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      newsCategoriesList.length,
                      (index) => newsCategoriesList[index] == kChooseCategory
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: () {
                                print('pressed');
                                print(newsCategoriesList[index]);
                                selectedNewsCategory.value =
                                    newsCategoriesList[index];
                              },
                              child: Obx(
                                () => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 9.w, vertical: 3.h),
                                  decoration: BoxDecoration(
                                    color: selectedNewsCategory.value ==
                                            newsCategoriesList[index]
                                        ? kGreenColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    newsCategoriesList[index],
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: selectedNewsCategory.value ==
                                              newsCategoriesList[index]
                                          ? Colors.white
                                          : Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  );
                }
                return Column(
                  children: const [
                    Center(child: CircularLoading()),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
