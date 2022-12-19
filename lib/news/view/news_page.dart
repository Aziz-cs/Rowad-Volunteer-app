import 'package:app/news/model/news.dart';
import 'package:app/news/view/widgets/filter_bar.dart';
import 'package:app/news/view/widgets/item_news.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants.dart';
import '../../widgets/menu_drawer.dart';

class NewsPage extends StatelessWidget {
  NewsPage({Key? key}) : super(key: key);
  var selectedNewsCategory = kAllNewsCategory.obs;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuDrawer(),
      appBar: AppBar(
        backgroundColor: kGreenColor,
        leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            }),
        title: Text(
          'المركز الإعلامي',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_list,
              color: kGreenColor,
            ),
            onPressed: () {},
          ),
        ],
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
          NewsFilterBar(selectedNewsCategory: selectedNewsCategory),
          Obx(
            () => StreamBuilder<QuerySnapshot>(
              stream: selectedNewsCategory.value == kAllNewsCategory
                  ? FirebaseFirestore.instance
                      .collection('news')
                      .orderBy('timestamp', descending: false)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('news')
                      .where('category', isEqualTo: selectedNewsCategory.value)
                      .snapshots(),
              builder: ((context, snapshot) {
                List<NewsItem> newsItems = [];
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
                      newsItems.add(NewsItem(news: news));
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
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
