import 'package:app/utils/constants.dart';
import 'package:app/widgets/navigator_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'start/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'utils/sharedprefs.dart';

const String appVersion = 'v1.3.0';

FirebaseApp? initFirebaseSdk;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initFirebaseSdk = await Firebase.initializeApp();
  await sharedPrefs.init();
  print('email: ${FirebaseAuth.instance.currentUser?.email}');
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
            scaffoldBackgroundColor: kOffWhite,
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
          home: FirebaseAuth.instance.currentUser?.email != null
              ? NavigatorPage()
              : SplashPage(),

          // home: StreamBuilder<User?>(
          //   stream: FirebaseAuth.instance.authStateChanges(),
          //   builder: (context, snapshot) {
          //     print('data changed');
          //     if (snapshot.connectionState == ConnectionState.active) {
          //       if (snapshot.hasData) {
          //         print('data has data');

          //         if (snapshot.data!.isAnonymous) {
          //           return SplashPage();
          //         }
          //         return NavigatorPage();
          //       }
          //     }
          //     return SplashPage();
          //   },
          // ),
          // home: SplashPage(),
        );
      },
    );
  }
}
