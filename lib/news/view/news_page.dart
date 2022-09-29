import 'item_news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'المركز الإعلامي',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'ترتيب حسب',
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1,
                  ),
                ),
                SizedBox(width: 3.w),
                const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List.generate(
                8,
                (index) => NewsItem(),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
