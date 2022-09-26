import 'package:app/view/tabs/home_page.dart';
import 'package:app/view/navigator_page.dart';
import 'package:app/view/splash_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'model/news.dart';
import 'utils/sharedprefs.dart';

List<News> allNews = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await sharedPrefs.init();
  // FirebaseFirestore.instance.collection('news').get().then((value) {
  //   print(value.docs.first.data());
  // });

  // await FirebaseFirestore.instance.collection('news').get().then((snapshot) {
  //   snapshot.docs.forEach((element) {
  //     News news = News.fromRTDB(element.data(), element.id);
  //     allNews.add(news);
  //   });
  //   allNews.forEach(
  //     (element) {
  //       print('Title: ${element.title}');
  //       print('SubTitle: ${element.subTitle}');
  //       print('Details: ${element.details}');
  //       print('ID: ${element.id}');
  //       print('=======');
  //     },
  //   );
  // });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Din',
            textTheme: const TextTheme(
              bodyText1: TextStyle(),
              bodyText2: TextStyle(),
            ).apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
          ),
          home: const SplashPage(),
        );
      },
    );
  }
}
