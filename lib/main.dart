import 'package:app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'splash/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'news/model/news.dart';
import 'utils/sharedprefs.dart';

List<News> allNews = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await sharedPrefs.init();
  await FirebaseAuth.instance.signInAnonymously();

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
            colorScheme: ThemeData().colorScheme.copyWith(
                  secondary: kGreenColor,
                ),
            fontFamily: 'Din',
            appBarTheme: Theme.of(context).appBarTheme.copyWith(
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  backgroundColor: kGreenColor,
                  centerTitle: true,
                ),
            // platform: TargetPlatform.android,
            // highlightColor: kGreenColor,
            splashColor: kGreenColor,
          ),
          home: SplashPage(),
        );
      },
    );
  }
}
