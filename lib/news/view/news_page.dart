import 'package:app/news/model/news.dart';
import 'package:app/news/view/widgets/item_news_list.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('news')
                .orderBy('timestamp')
                .snapshots(),
            builder: ((context, snapshot) {
              List<NewsListItem> newsItems = [];
              print(snapshot.connectionState.toString());
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasError) {
                  print('has error in loading news');
                  return const Center(child: Text('هناك خطأ ما'));
                }
                var newsResult = snapshot.data!.docs;
                newsResult.forEach(
                  (newsElement) {
                    News news = News.fromDB(
                      newsElement.data() as Map<String, dynamic>,
                      newsElement.id,
                    );
                    newsItems.add(NewsListItem(news: news));
                  },
                );
                return Column(
                  children: newsItems.reversed.toList(),
                );
                // Expanded(
                //   child: GridView.count(
                //     padding: EdgeInsets.zero,
                //     shrinkWrap: true,
                //     crossAxisCount: 2,
                //     childAspectRatio: 0.98,
                //     mainAxisSpacing: 8,
                //     crossAxisSpacing: 8,
                //     children: newsItems.reversed.toList(),
                //   ),
                // );
              }
              return Column(
                children: const [
                  Center(child: CircularLoading()),
                ],
              );
            }),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
