import 'package:app/profile/controller/profile_controller.dart';
import 'package:app/profile/view/complete_profile.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/navigator_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoadingRegisterNewAccount = false.obs;
  var isLoadingLoggingIn = false.obs;
  //create new account
  Future<void> registerNewAccount({
    required String email,
    required String password,
  }) async {
    isLoadingRegisterNewAccount.value = true;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Get.offAll(() => CompleteProfile());
      });
    } on FirebaseAuthException catch (e) {
      isLoadingRegisterNewAccount.value = false;

      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Fluttertoast.showToast(msg: 'كلمة سر ضعيفة جداً');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'هذا البريد تم تسجيله مسبقاً');
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    isLoadingLoggingIn.value = true;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((userCredential) async {
        setUserInitialData().then((value) {
          isLoadingLoggingIn.value = false;
          Get.offAll(() => NavigatorPage());
        });
      });
    } on FirebaseAuthException catch (e) {
      isLoadingLoggingIn.value = false;

      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Fluttertoast.showToast(msg: 'لا يوجد تسجيل لدينا بهذا البريد');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Fluttertoast.showToast(msg: 'كلمة سر غير صحيحة');
      } else {
        Fluttertoast.showToast(msg: kErrSomethingWrong);
      }
    } catch (e) {
      isLoadingLoggingIn.value = false;

      print('error while signing in $e');
      Fluttertoast.showToast(msg: kErrSomethingWrong);
    }
  }
}
