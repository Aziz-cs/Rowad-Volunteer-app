import 'package:app/auth/controller/auth_controller.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/sharedprefs.dart';
import 'package:app/widgets/circle_logo.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:app/widgets/navigator_page.dart';
import 'package:app/widgets/simple_btn.dart';
import 'package:app/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/utils.dart';
import 'package:get/get.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});
  var authController = Get.put(AuthController());

  final isOpenedNewRegister = false.obs;
  var isLoadingSignInAsGuest = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var newEmailController = TextEditingController();
  var newPasswordController = TextEditingController();
  var newPasswordRepeatController = TextEditingController();

  var email = TextEditingController();
  final _formKeyRegister = GlobalKey<FormState>();
  final _formKeyLogin = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenColor,
        centerTitle: true,
        title: const Text('أهلاً ومرحباً'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              key: _formKeyLogin,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(
                      () => isOpenedNewRegister.isTrue
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: const RowadCircleLogo(
                                radius: 100,
                              ),
                            )
                          : AnimatedOpacity(
                              opacity: isOpenedNewRegister.value ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 500),
                              child: Column(
                                children: [
                                  SizedBox(height: 30.h),
                                  const Text(
                                    'تسجيل دخول',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: const [
                                      Text(
                                        'البريد الإلكتروني',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  MyTextField(
                                      isLTRdirection: true,
                                      controller: emailController,
                                      validator: (input) {
                                        if (!GetUtils.isEmail(input!)) {
                                          return 'برجاء كتابة بريد إلكتروني صحيح';
                                        }
                                      }),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: const [
                                      Text(
                                        'كلمة السر',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  MyTextField(
                                      controller: passwordController,
                                      isObsecure: true,
                                      isLTRdirection: true,
                                      validator: (input) {
                                        if (input!.length < 6) {
                                          return kErrPassTooShort;
                                        }
                                      }),
                                  SizedBox(height: 10.h),
                                  Obx(() => authController
                                          .isLoadingLoggingIn.isTrue
                                      ? const CircularLoading()
                                      : SimpleButton(
                                          label: 'تسجيل دخول',
                                          onPress: () async {
                                            await authController.signIn(
                                              email:
                                                  emailController.text.trim(),
                                              password: passwordController.text
                                                  .trim(),
                                            );
                                            // Get.offAll(() => NavigatorPage());
                                          },
                                        )),
                                  Obx(() => isLoadingSignInAsGuest.isTrue
                                      ? const CircularLoading()
                                      : SimpleButton(
                                          label: 'الدخول كضيف',
                                          onPress: () async {
                                            isLoadingSignInAsGuest.value = true;
                                            await FirebaseAuth.instance
                                                .signInAnonymously()
                                                .then((value) {
                                              Get.offAll(() => NavigatorPage());
                                            });
                                          },
                                        )),
                                  SizedBox(height: 20.h),
                                  InkWell(
                                    onTap: () {
                                      isOpenedNewRegister.value = true;
                                    },
                                    // onTap: () => Get.offAll(() => const RegisterPage()),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'ليس لديك حساب؟',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'سجل الآن',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: kGreenColor,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    Obx(() => AnimatedOpacity(
                          opacity: isOpenedNewRegister.value ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Form(
                            key: _formKeyRegister,
                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      'البريد الإلكتروني',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                MyTextField(
                                    controller: newEmailController,
                                    isLTRdirection: true,
                                    validator: (input) {
                                      if (!GetUtils.isEmail(input!)) {
                                        return 'برجاء كتابة بريد إلكتروني صحيح';
                                      }
                                    }),
                                const SizedBox(height: 5),
                                Row(
                                  children: const [
                                    Text(
                                      'كلمة السر',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                MyTextField(
                                    controller: newPasswordController,
                                    isLTRdirection: true,
                                    isObsecure: true,
                                    validator: (input) {
                                      if (input!.length < 6) {
                                        return kErrPassTooShort;
                                      }
                                    }),
                                Row(
                                  children: const [
                                    Text(
                                      'إعادة كلمة السر',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                MyTextField(
                                    controller: newPasswordRepeatController,
                                    isLTRdirection: true,
                                    isObsecure: true,
                                    validator: (input) {
                                      if (input!.length < 6) {
                                        return kErrPassTooShort;
                                      }
                                      if (input !=
                                          newPasswordController.text.trim()) {
                                        return 'كلمتيّ السر ليسوا سواء';
                                      }
                                    }),
                                SizedBox(height: 15.h),
                                Obx(() => authController
                                        .isLoadingRegisterNewAccount.isTrue
                                    ? const Center(
                                        child: CircularLoading(),
                                      )
                                    : SimpleButton(
                                        label: 'تسجيل متطوع جديد',
                                        onPress: () {
                                          if (!_formKeyRegister.currentState!
                                              .validate()) {
                                            return;
                                          }

                                          authController.registerNewAccount(
                                              email: newEmailController.text
                                                  .trim(),
                                              password: newPasswordController
                                                  .text
                                                  .trim());
                                        },
                                      )),
                                if (isOpenedNewRegister.isTrue)
                                  InkWell(
                                    onTap: () {
                                      isOpenedNewRegister.value = false;
                                    },
                                    // onTap: () => Get.offAll(() => const RegisterPage()),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'عندك عضوية بالفعل؟',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'تسجيل دخول',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: kGreenColor,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
