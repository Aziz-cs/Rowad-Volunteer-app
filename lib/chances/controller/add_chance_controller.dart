import 'package:get/get.dart';

enum Gender { male, female, both }

class AddChanceController extends GetxController {
  var genderType = Gender.male.obs;
  var isTeamWork = false.obs;
  var isOnline = false.obs;
  var isUrgent = false.obs;
  var isSupportDisabled = false.obs;
  var isNeedInterview = false.obs;
}
